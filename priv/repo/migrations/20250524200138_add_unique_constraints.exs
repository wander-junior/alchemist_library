defmodule Library.Repo.Migrations.AddUniqueConstraints do
  use Ecto.Migration

  def change do
    create unique_index(:authors, [:name])
    create unique_index(:books, [:isbn])
  end
end
