defmodule Exred.Scheduler.DeployManager do
  @moduledoc """
  Manages the deployment of flows
  """

  require Logger

  alias Exred.Library
  alias Exred.Library.Node
  alias Exred.Library.Connection
  alias Exred.Scheduler.DeploymentSupervisor
  alias Exred.Scheduler.DaemonNodeSupervisor
  alias Exred.Scheduler.CommandChannel

  use GenServer

  # API

  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: __MODULE__)
  end

  def deploy do
    GenServer.call(__MODULE__, :deploy, 30000)
  end

  # Callbacks
  def init(_args) do
    {:ok, %{}}
  end

  def handle_call(:deploy, _from, state) do
    Logger.info("Starting deployment")

    terminate_node_processes()
    # TODO: should we terminate the daemon processes here? or let them run forever?
    start_node_processes()
    set_up_connections()

    Logger.info("Deployed flows")
    CommandChannel.send("notification", %{msg: "Deployed Flows"})
    {:reply, :ok, state}
  end

  @doc """
  terminate all running processes
  """
  defp terminate_node_processes do
    children = Supervisor.which_children(DeploymentSupervisor)

    children
    |> Enum.each(fn
      {child_id, :restarting, _, child_modules} ->
        Logger.warn(
          "Couldn't terminate #{child_id} (in the process of restarting). Module: #{
            inspect(child_modules)
          }"
        )

      {child_id, _child_pid, _child_type, _child_modules} ->
        :ok = Supervisor.terminate_child(DeploymentSupervisor, child_id)
        :ok = Supervisor.delete_child(DeploymentSupervisor, child_id)
    end)

    Logger.info("terminated child processes")
  end

  @doc """
  get nodes from library and start instances
  """
  defp start_node_processes do
    nodes = Library.get_all_nodes()

    ## sort nodes; put daemon nodes first
    sorted_nodes =
      nodes
      |> Enum.sort(fn n1, _n2 -> n1.category == "daemon" end)

    ## start node instances
    sorted_nodes
    |> Enum.each(fn %Node{} = node ->
      Logger.info("STARTING NODE INSTANCE: #{node.name}")

      if node.category == "daemon" do
        # start the daemon childs
        node.module.daemon_child_specs(node.config)
        |> Enum.each(&start_daemon_process/1)
      end

      start_args = [node.id, node.config, &Exred.Scheduler.EventChannel.send/2]
      child_spec = Supervisor.child_spec({node.module, start_args}, id: node.id)

      # TODO: what are we going to do when a child doesn't start up?
      # ignore and deploy rest of flow OR abort and report failed deployment
      {:ok, _pid} = Supervisor.start_child(DeploymentSupervisor, child_spec)
    end)

    Logger.info("started child processes")
  end

  @doc """
    get connections from library and set them up on the nodes
  """
  defp set_up_connections do
    connections = Library.get_all_connections()

    Enum.each(connections, fn %Connection{} = conn ->
      # can't call the node module's API to add a new connection because
      # we don't know what module it is
      # so we just call directly with GenServer
      # (source_id matches the node process's registered name)
      GenServer.call(conn.source_id, {:add_out_node, conn.target_id})
      Logger.info("ADDED CONNECTION: #{conn.source_id} -> #{conn.target_id}")
    end)

    Logger.info("Set up connections")
  end

  def start_daemon_process(child_spec) do
    case DaemonNodeSupervisor.start_child(child_spec) do
      {:ok, _pid} ->
        Logger.info("started: #{inspect(child_spec)}")
        :ok

      {:error, {:already_started, _pid}} ->
        Logger.info("already running: #{inspect(child_spec)}")
        :ok

      {:error, reason} ->
        error_msg = "failed to start gRPC server: #{inspect(reason)}"
        Logger.error(error_msg)
        {:error, error_msg}
    end
  end
end
