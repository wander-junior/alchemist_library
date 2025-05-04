defmodule :"Elixir.library.Repo.Migrations.CreateAuthors" do
  use Ecto.Migration

  def change do
    create table(:authors) do
      add :name, :string, null: false

      timestamps()
    end
  end
end
