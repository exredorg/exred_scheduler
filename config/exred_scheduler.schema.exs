# extends: [:exred_library, :exred_node_aws_iot_daemon],
# extends doesn't seem to work to extend schemas from dependencies since it cannot find the dependency's schemas
# need to copy any schema here that we want to extend
# (eg. schema from :exred_library)

[
  extends: [],
  import: [],
  mappings: [
    "exred_library.psql_conn.username": [
      commented: false,
      datatype: :binary,
      default: "exred_user",
      doc: "DB username",
      hidden: false,
      env_var: "EXRED_DB_USERNAME",
      to: "exred_library.psql_conn.username"
    ],
    "exred_library.psql_conn.password": [
      commented: false,
      datatype: :binary,
      doc: "DB password",
      hidden: false,
      env_var: "EXRED_DB_PASSWORD",
      to: "exred_library.psql_conn.password"
    ],
    "exred_library.psql_conn.database": [
      commented: false,
      datatype: :binary,
      default: "exred_ui_dev",
      doc: "DB name",
      hidden: false,
      env_var: "EXRED_DB_NAME",
      to: "exred_library.psql_conn.database"
    ],
    "exred_library.psql_conn.hostname": [
      commented: false,
      datatype: :binary,
      default: "localhost",
      doc: "DB server hostname",
      hidden: false,
      env_var: "EXRED_DB_HOSTNAME",
      to: "exred_library.psql_conn.hostname"
    ],
    "exred_library.psql_conn.port": [
      commented: false,
      datatype: :integer,
      default: 5432,
      doc: "DB server port",
      hidden: false,
      env_var: "EXRED_DB_PORT",
      to: "exred_library.psql_conn.port"
    ],
    "exred_scheduler.exred_ui_hostname": [
      commented: false,
      datatype: :binary,
      default: "localhost",
      doc:
        "Hostname where the exred_ui application is running (needed to access Phoenix channels)",
      hidden: false,
      env_var: "EXRED_UI_HOSTNAME",
      to: "exred_scheduler.exred_ui_hostname"
    ],
    "exred_scheduler.exred_ui_port": [
      commented: false,
      datatype: :integer,
      default: 4000,
      doc: "Port where the exred_ui application is running (needed to access Phoenix channels)",
      hidden: false,
      env_var: "EXRED_UI_PORT",
      to: "exred_scheduler.exred_ui_port"
    ],
    "exred_node_aws_iot_daemon.ssl.keyfile": [
      commented: false,
      datatype: :binary,
      default: "~/exred_data/private.pem.key",
      doc:
        "Private key to connect to AWS IOT (see https://console.aws.amazon.com/iot/home?region=us-east-1#/certificatehub)",
      hidden: false,
      env_var: "EXRED_AWSIOT_PRIVATE_KEY",
      to: "exred_node_aws_iot_daemon.ssl.keyfile"
    ],
    "exred_node_aws_iot_daemon.ssl.certfile": [
      commented: false,
      datatype: :binary,
      default: "~/exred_data/certificate.pem.crt",
      doc:
        "Certificate to connect to AWS IOT (see https://console.aws.amazon.com/iot/home?region=us-east-1#/certificatehub)",
      hidden: false,
      env_var: "EXRED_AWSIOT_CERTIFICATE",
      to: "exred_node_aws_iot_daemon.ssl.certfile"
    ],
    "exred_node_aws_iot_daemon.ssl.cacertfile": [
      commented: false,
      datatype: :binary,
      default: "~/exred_data/ca_root.pem",
      doc:
        "CA Certificate to connect to AWS IOT (see https://console.aws.amazon.com/iot/home?region=us-east-1#/certificatehub)",
      hidden: false,
      env_var: "EXRED_AWSIOT_CACERTIFICATE",
      to: "exred_node_aws_iot_daemon.ssl.cacertfile"
    ]
  ],
  transforms: [],
  validators: []
]
