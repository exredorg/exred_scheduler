defmodule Exred.Scheduler.Mixfile do
  use Mix.Project

  def project do
    [
      app: :exred_scheduler,
      version: "0.1.1",
      build_path: "./_build",
      config_path: "./config/config.exs",
      deps_path: "./deps",
      lockfile: "./mix.lock",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Exred.Scheduler.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:phoenix_gen_socket_client, "~> 2.1.1"},
      {:websocket_client, "~> 1.2"},
      {:poison, "~> 2.0"},
      {:ex_doc, "~> 0.19.0", only: :dev, runtime: false},
      {:distillery, "~> 1.5", runtime: false},
      {:conform, "~> 2.2"}
    ] ++ nodes(Mix.env())
  end

  defp nodes(:prod) do
    [
      {:exred_library, "~> 0.1"},
      {:exred_node_aws_iot_daemon, "~> 0.1.0"},
      {:exred_node_aws_iot_thingshadow_in, "~> 0.1.0"},
      {:exred_node_aws_iot_thingshadow_out, "~> 0.1.0"},
      {:exred_node_debug, "~> 0.1.0"},
      {:exred_node_gpio_in, "~> 0.1.0"},
      {:exred_node_gpio_out, "~> 0.1.0"},
      {:exred_node_redis_daemon, "~> 0.1.0"},
      {:exred_node_redis_in, "~> 0.1.0"},
      {:exred_node_redis_out, "~> 0.1.0"},
      {:exred_node_suppress, "~> 0.1.0"},
      {:exred_node_trigger, "~> 0.1.0"},
      {:exred_node_rpiphoto, "~> 0.1.0"},
      {:exred_node_shell, "~> 0.1.0"},
      {:exred_node_picar, "~> 0.1.0"},
      {:exred_node_function, "~> 0.1.0"},
      {:exred_node_grpc_server, "~> 0.1.2-alpha2"},
      {:exred_node_grpc_twin, "~> 0.1.0"}
    ]
  end

  defp nodes(:dev) do
    [
      # {:exred_library, git: "https://github.com/exredorg/exred_library.git"},
      # {:exred_node_aws_iot_daemon,
      #  git: "https://github.com/exredorg/exred_node_aws_iot_daemon.git"},
      # {:exred_node_aws_iot_thingshadow_in,
      #  git: "https://github.com/exredorg/exred_node_aws_iot_thingshadow_in.git"},
      # {:exred_node_aws_iot_thingshadow_out,
      #  git: "https://github.com/exredorg/exred_node_aws_iot_thingshadow_out.git"},
      # {:exred_node_debug, git: "https://github.com/exredorg/exred_node_debug.git"},
      {:exred_node_debug, path: "../../../exred_node_debug"},
      # {:exred_node_gpio_in, git: "https://github.com/exredorg/exred_node_gpio_in.git"},
      # {:exred_node_gpio_out, git: "https://github.com/exredorg/exred_node_gpio_out.git"},
      # {:exred_node_redis_daemon, git: "https://github.com/exredorg/exred_node_redis_daemon.git"},
      # {:exred_node_redis_in, git: "https://github.com/exredorg/exred_node_redis_in.git"},
      # {:exred_node_redis_out, git: "https://github.com/exredorg/exred_node_redis_out.git"},
      # {:exred_node_suppress, git: "https://github.com/exredorg/exred_node_suppress.git"},
      # {:exred_node_trigger, git: "https://github.com/exredorg/exred_node_trigger.git"},
      {:exred_node_trigger, path: "../../../exred_node_trigger"},
      # {:exred_node_rpiphoto, git: "https://github.com/exredorg/exred_node_rpiphoto.git"},
      # {:exred_node_shell, git: "https://github.com/exredorg/exred_node_shell.git"},
      # {:exred_node_picar, git: "https://github.com/exredorg/exred_node_picar.git"},
      # {:exred_node_function, git: "https://github.com/exredorg/exred_node_function.git"},
      # {:exred_node_grpc_server, git: "https://github.com/exredorg/exred_node_grpc_server.git" },
      # {:exred_node_grpc_twin, git: "https://github.com/exredorg/exred_node_grpc_twin.git" }
      # {:exred_node_grpc_server, path: "../../../exred_node_grpc_server"},
      # {:exred_node_grpc_twin, path: "../../../exred_node_grpc_twin"},
      {:exred_library, path: "../../../exred_library"}
    ]
  end
end
