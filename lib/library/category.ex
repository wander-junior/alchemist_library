defmodule Library.Category do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  schema "categories" do
    field(:name, :string)

    timestamps()
  end

  def changeset(struct, params) do
    struct
    |> cast(params, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end

  def create_category(attrs) do
    %__MODULE__{}
    |> Library.Category.changeset(attrs)
    |> Library.Repo.insert()
  end

  def get_all() do
    query = from(Library.Category)
    Library.Repo.all(query)
  end

  def get_by_name(name) do
    Library.Repo.get_by(Library.Category, name: name)
  end

  def update_category(id, new_category) do
    category = Library.Repo.get!(Library.Category, id)
    category = change(category, name: new_category)

    Library.Repo.update(category)
  end

  def delete_category(name) do
    category = get_by_name(name)
    Library.Repo.delete(category)
  end
end
