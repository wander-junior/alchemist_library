defmodule Library.Book do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  schema "books" do
    field(:title, :string)
    field(:isbn, :string)
    field(:price, :integer, default: 0)

    belongs_to(:author, Library.Author)
    belongs_to(:category, Library.Category)

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
    %__MODULE__{}
    |> Library.Book.changeset(attrs)
    |> Library.Repo.insert()
  end

  def get_all(filters \\ %{}) do
    price_filter(Library.Book, filters)
    |> Library.Repo.all()
  end

  def get_by_title(title) do
    from(b in Library.Book,
      where: ilike(b.title, ^"%#{String.replace(title, "%", "\\%")}%")
    )
    |> Library.Repo.all()
  end

  def get_by_authors_name(name, filters \\ %{}) do
    from(b in Library.Book,
      join: a in assoc(b, :author),
      where: a.name == ^name,
      preload: [author: a]
    )
    |> price_filter(filters)
    |> Library.Repo.all()
  end

  def get_by_category_name(name, filters \\ %{}) do
    from(b in Library.Book,
      join: c in assoc(b, :category),
      where: c.name == ^name,
      preload: [category: c]
    )
    |> price_filter(filters)
    |> Library.Repo.all()
  end

  def update_book(id, new_book) do
    with %Library.Book{} = book <- Library.Repo.get(Library.Book, id),
         changeset = Library.Book.changeset(book, new_book),
         {:ok, updated_book} <- Library.Repo.update(changeset) do
      {:ok, updated_book}
    else
      nil ->
        {:error, :not_found}

      {:error, changeset} ->
        {:error, changeset}
    end
  end

  def delete_book(id) do
    with %Library.Book{} = book <- Library.Repo.get(Library.Book, id),
         {:ok, deleted_book} <- Library.Repo.delete(book) do
      {:ok, deleted_book}
    else
      nil ->
        {:error, :not_found}

      {:error, changeset} ->
        {:error, changeset}
    end
  end
end
