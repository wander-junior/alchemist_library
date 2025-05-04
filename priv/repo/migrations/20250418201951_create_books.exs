defmodule :"Elixir.library.Repo.Migrations.CreateBooks" do
  use Ecto.Migration

  def change do
    create table(:books) do
      add :title, :string, null: false
      add :isbn, :string, null: false
      add :price, :integer, default: 0
      add :author_id, references(:authors)
      add :category_id, references(:categories)
    end
  end
end
