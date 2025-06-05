import Config

config :alchemist_library,
  ecto_repos: [Library.Repo]

import_config "#{config_env()}.exs"
