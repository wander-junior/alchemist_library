defmodule AlchemistLibrary.Library.Author do
  alias AlchemistLibrary.{Repo, Library, Cache}
  alias Library.Author

  use Ecto.Schema
  use Nebulex.Caching.Decorators

  import Ecto.Changeset
  import Ecto.Query

  @derive {Jason.Encoder, only: [:id, :name]}
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
    |> Author.changeset(attrs)
    |> Repo.insert()
  end

  def get_all() do
    from(Author)
    |> Repo.all()
  end

  @decorate cacheable(
              cache: Cache,
              key: {:author_by_name, name},
              opts: [ttl: 60_000]
            )
  def get_by_name(name) do
    Repo.get_by(Author, name: name)
  end

  def update_author(id, new_author) do
    with %Author{} = author <-
           Repo.get(Author, id),
         changeset = changeset(author, new_author),
         {:ok, updated_author} <- Repo.update(changeset) do
      {:ok, updated_author}
    else
      nil ->
        {:error, :not_found}

      {:error, changeset} ->
        {:error, changeset}
    end
  end

  def delete_author(id) do
    with %Author{} = author <-
           Repo.get(Author, id),
         {:ok, deleted_author} <- Repo.delete(author) do
      {:ok, deleted_author}
    else
      nil ->
        {:error, :not_found}

      {:error, changeset} ->
        {:error, changeset}
    end
  end

  def delete_author_by_name(name) do
    with %Author{} = author <-
           get_by_name(name),
         {:ok, deleted_author} <- Repo.delete(author) do
      Cache.delete({:author_by_name, name})
      {:ok, deleted_author}
    else
      nil ->
        {:error, :not_found}

      {:error, changeset} ->
        {:error, changeset}
    end
  end
end
