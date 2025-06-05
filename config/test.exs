import Config

config :alchemist_library, Library.Repo,
  username: "postgres",
  password: "1234",
  database: "library_test",
  hostname: "localhost",

  pool: Ecto.Adapters.SQL.Sandbox
