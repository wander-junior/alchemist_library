defmodule AlchemistLibrary.Library.Category do
  alias AlchemistLibrary.{Repo, Library, Cache}
  alias Library.Category

  use Ecto.Schema
  use Nebulex.Caching.Decorators

  import Ecto.Changeset
  import Ecto.Query

  @derive {Jason.Encoder, only: [:id, :name]}
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
    |> changeset(attrs)
    |> Repo.insert()
  end

  def get_all() do
    from(Category)
    |> Repo.all()
  end

  @decorate cacheable(
              cache: Cache,
              key: {:category_by_name, name},
              opts: [ttl: 60_000]
            )
  def get_by_name(name) do
    Repo.get_by(Category, name: name)
  end

  def update_category(id, new_category) do
    with %Category{} = category <- Repo.get(Category, id),
         changeset = changeset(category, new_category),
         {:ok, updated_category} <- Repo.update(changeset) do
      {:ok, updated_category}
    else
      nil ->
        {:error, :not_found}

      {:error, changeset} ->
        {:error, changeset}
    end
  end

  def delete_category(id) do
    with %Category{} = category <- Repo.get(Category, id),
         {:ok, deleted_category} <- Repo.delete(category) do
      {:ok, deleted_category}
    else
      nil ->
        {:error, :not_found}

      {:error, changeset} ->
        {:error, changeset}
    end
  end

  def delete_category_by_name(name) do
    with %Category{} = category <- get_by_name(name),
         {:ok, deleted_category} <- Repo.delete(category) do
      Cache.delete({:category_by_name, name})
      {:ok, deleted_category}
    else
      nil ->
        {:error, :not_found}

      {:error, changeset} ->
        {:error, changeset}
    end
  end
end
