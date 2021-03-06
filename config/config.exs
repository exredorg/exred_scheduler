# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

# This configuration is loaded before any dependency and is restricted
# to this project. If another project depends on this project, this
# file won't be loaded nor affect the parent project. For this reason,
# if you want to provide default values for your application for
# 3rd-party users, it should be done in your "mix.exs" file.

# You can configure your application as:
#
#     config :exred_scheduler, key: :value
#
# and access this configuration in your application as:
#
#     Application.get_env(:exred_scheduler, :key)
#
# You can also configure a 3rd-party app:
#
#     config :logger, level: :info
#

# It is also possible to import configuration files, relative to this
# directory. For example, you can emulate configuration per environment
# by uncommenting the line below and defining dev.exs, test.exs and such.
# Configuration from the imported file will override the ones defined
# here (which is why it is important to import them last).
#
#     import_config "#{Mix.env}.exs

config :exred_scheduler, :exred_ui_hostname, "localhost"
config :exred_scheduler, :exred_ui_port, 4000

config :logger, :console,
  format: "[$level] $metadata$message\n",
  metadata: [:module, :function]

config :exred_library, :psql_conn,
  username: "exred_user",
  password: "hello",
  database: "exred_ui_dev",
  hostname: "localhost",
  port: 5432

config :grpc, start_server: true

config :exred_node_aws_iot_daemon, :ssl,
  keyfile: "~/exred_data/private.pem.key",
  certfile: "~/exred_data/certificate.pem.crt",
  cacertfile: "~/exred_data/ca_root.pem"
