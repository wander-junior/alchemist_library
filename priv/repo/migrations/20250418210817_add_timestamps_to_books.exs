defmodule :"Elixir.library.Repo.Migrations.AddTimestampsToBooks" do
  use Ecto.Migration

  def change do
    alter table(:books) do
      timestamps()
    end
  end
end
