defmodule :"Elixir.library.Repo" do
  use Ecto.Repo,
    otp_app: :alchemist_library,
    adapter: Ecto.Adapters.Postgres
end
