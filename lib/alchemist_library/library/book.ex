defmodule AlchemistLibrary.Library.Book do
  alias AlchemistLibrary.{Cache, Repo}
  alias AlchemistLibrary.Library.{Author, Category, Book}

  use Ecto.Schema
  use Nebulex.Caching.Decorators

  import Ecto.Changeset
  import Ecto.Query

  @derive {Jason.Encoder, only: [:id, :title, :isbn, :price, :author, :category]}
  schema "books" do
    field(:title, :string)
    field(:isbn, :string)
    field(:price, :integer, default: 0)

    belongs_to(:author, Author)
    belongs_to(:category, Category)

    timestamps()
  end

  def changeset(struct, params) do
    struct
    |> cast(params, [:title, :isbn, :price, :author_id, :category_id])
    |> validate_required([:title, :isbn, :author_id, :category_id])
    |> assoc_constraint(:author)
    |> assoc_constraint(:category)
    |> validate_length(:isbn, is: 13)
    |> validate_number(:price, greater_than_or_equal_to: 0)
    |> unique_constraint(:isbn)
  end

  defp price_filter(acc, filters) do
    Enum.reduce(filters, acc, fn
      {:min_price, min_price}, query -> from(b in query, where: b.price >= ^min_price)
      {:max_price, max_price}, query -> from(b in query, where: b.price <= ^max_price)
      _, query -> query
    end)
  end

  def create_book(attrs) do
    changeset = Book.changeset(%Book{}, attrs)

    case Repo.insert(changeset) do
      {:ok, book} ->
        book = Repo.preload(book, [:author, :category])
        {:ok, book}

      {:error, changeset} ->
        {:error, changeset}
    end
  end

  def get_all(filters \\ %{}) do
    price_filter(Book, filters)
    |> Repo.all()
    |> Repo.preload(:author)
    |> Repo.preload(:category)
  end

  @decorate cacheable(
              cache: Cache,
              key: {:book_by_title, title},
              opts: [ttl: 60_000]
            )
  def get_by_title(title) do
    from(b in Book,
      where: ilike(b.title, ^"%#{String.replace(title, "%", "\\%")}%")
    )
    |> Repo.all()
    |> Repo.preload(:author)
    |> Repo.preload(:category)
  end

  def get_by_authors_name(name, filters \\ %{}) do
    from(b in Book,
      join: a in assoc(b, :author),
      where: a.name == ^name,
      preload: [author: a]
    )
    |> price_filter(filters)
    |> Repo.all()
    |> Repo.preload(:category)
  end

  def get_by_category_name(name, filters \\ %{}) do
    from(b in Book,
      join: c in assoc(b, :category),
      where: c.name == ^name,
      preload: [category: c]
    )
    |> price_filter(filters)
    |> Repo.all()
    |> Repo.preload(:author)
    |> Repo.preload(:category)
  end

  def update_book(id, new_book) do
    with %Book{} = book <- Repo.get(Library.Book, id),
         changeset = Book.changeset(book, new_book),
         {:ok, updated_book} <- Repo.update(changeset),
         preloaded_book <- Repo.preload(updated_book, [:author, :category]) do
      {:ok, preloaded_book}
    else
      nil ->
        {:error, :not_found}

      {:error, changeset} ->
        {:error, changeset}
    end
  end

  def delete_book(id) do
    with %Book{} = book <- Repo.get(Library.Book, id),
         {:ok, deleted_book} <- Repo.delete(book),
         preloaded_book <- Repo.preload(deleted_book, [:author, :category]) do
      {:ok, preloaded_book}
    else
      nil ->
        {:error, :not_found}

      {:error, changeset} ->
        {:error, changeset}
    end
  end
end
