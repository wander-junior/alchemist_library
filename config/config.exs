import Config

config :alchemist_library,
  ecto_repos: [AlchemistLibrary.Repo]

config :alchemist_library, AlchemistLibrary.Cache,
  adapter: NebulexRedisAdapter,
  conn_opts: [
    host: "localhost",
    port: 6379
  ],
  pool_size: 5

import_config "#{config_env()}.exs"
