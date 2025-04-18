defmodule Library.Book do
  use Ecto.Schema
  import Ecto.Changeset

  schema "books" do
    field :title, :string
    field :isbn, :string
    field :price, :integer, default: 0

    belongs_to :author, Library.Author
    belongs_to :category, Library.Category

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
  end
end
