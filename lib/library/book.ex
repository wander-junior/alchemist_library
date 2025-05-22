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
    |> unique_constraint(:title)
  end

  def create_book(attrs) do
    %__MODULE__{}
    |> Library.Book.changeset(attrs)
    |> Library.Repo.insert()
  end

  def get_all() do
    query = from(Library.Book)
    Library.Repo.all(query)
  end

  def get_by_title(title) do
    Library.Repo.get_by(Library.Book, title: title)
  end

  def get_by_authors_name(name) do
    from(b in Library.Book,
      join: a in assoc(b, :author),
      where: a.name == ^name,
      preload: [author: a]
    )
    |> Library.Repo.all()
  end
end
