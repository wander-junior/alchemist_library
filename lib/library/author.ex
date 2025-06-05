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
    with %Library.Author{} = author <- Library.Repo.get(Library.Author, id),
         changeset = Library.Author.changeset(author, new_author),
         {:ok, updated_author} <- Library.Repo.update(changeset) do
      {:ok, updated_author}
    else
      nil ->
        {:error, :not_found}

      {:error, changeset} ->
        {:error, changeset}
    end
  end

  def delete_author(id) do
    with %Library.Author{} = author <- Library.Repo.get(Library.Author, id),
         {:ok, deleted_author} <- Library.Repo.delete(author) do
      {:ok, deleted_author}
    else
      nil ->
        {:error, :not_found}

      {:error, changeset} ->
        {:error, changeset}
    end
  end
end
