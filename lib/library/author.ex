defmodule Library.Author do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  schema "authors" do
    field(:name, :string)

    timestamps()
  end

  def changeset(struct, params) do
    struct
    |> cast(params, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end

  def create_author(attrs) do
    %__MODULE__{}
    |> Library.Author.changeset(attrs)
    |> Library.Repo.insert()
  end

  def get_all() do
    query = from(Library.Author)
    Library.Repo.all(query)
  end

  def get_by_name(name) do
    Library.Repo.get_by(Library.Author, name: name)
  end

  def update_author(id, new_author) do
    author = Library.Repo.get!(Library.Author, id)
    author = change(author, name: new_author)

    Library.Repo.update(author)
  end

  def delete_author(id) do
    author = Library.Repo.get!(Library.Author, id)
    Library.Repo.delete(author)
  end
end
