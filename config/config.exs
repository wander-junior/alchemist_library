import Config

config :alchemist_library, Library.Repo,
  database: "postgres",
  username: "postgres",
  password: "1234",
  hostname: "localhost"

config :alchemist_library,
  ecto_repos: [Library.Repo]
