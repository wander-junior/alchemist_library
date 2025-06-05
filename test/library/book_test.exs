defmodule Library.BookTest do
  use ExUnit.Case
  use Library.RepoCase

  describe "create_book/1" do
    test "should create book when all atrributes are valid" do
      {:ok, category} = Library.Category.create_category(%{name: "Categoria"})
      {:ok, author} = Library.Author.create_author(%{name: "Autor"})

      {status, response} =
        Library.Book.create_book(%{
          title: "Nome do livro",
          isbn: "0-6672-2445-9",
          price: 1234,
          author_id: author.id,
          category_id: category.id
        })

      assert status == :ok
      assert response.title == "Nome do livro"
      assert response.isbn == "0-6672-2445-9"
      assert response.price == 1234
      assert response.author_id == author.id
      assert response.category_id == category.id
    end

    test "should return error when title is invalid" do
      {:ok, category} = Library.Category.create_category(%{name: "Categoria"})
      {:ok, author} = Library.Author.create_author(%{name: "Autor"})

      {status, _} =
        Library.Book.create_book(%{
          title: "",
          isbn: "0-6672-2445-9",
          price: 1234,
          author_id: author.id,
          category_id: category.id
        })

      assert status == :error
    end

    test "should return error when isbn is invalid" do
      {:ok, category} = Library.Category.create_category(%{name: "Categoria"})
      {:ok, author} = Library.Author.create_author(%{name: "Autor"})

      {status, _} =
        Library.Book.create_book(%{
          title: "Nome do livro",
          isbn: "0-6672-2445-",
          author_id: author.id,
          category_id: category.id
        })

      assert status == :error
    end

    test "should initialize price with 0 when there is no price" do
      {:ok, category} = Library.Category.create_category(%{name: "Categoria"})
      {:ok, author} = Library.Author.create_author(%{name: "Autor"})

      {status, res} =
        Library.Book.create_book(%{
          title: "Nome do livro",
          isbn: "0-6672-2445-9",
          author_id: author.id,
          category_id: category.id
        })

      assert status == :ok
      assert res.price == 0
    end

    test "should return error when price is smaller than 0" do
      {:ok, category} = Library.Category.create_category(%{name: "Categoria"})
      {:ok, author} = Library.Author.create_author(%{name: "Autor"})

      {status, _} =
        Library.Book.create_book(%{
          title: "Nome do livro",
          isbn: "0-6672-2445-9",
          price: -1,
          author_id: author.id,
          category_id: category.id
        })

      assert status == :error
    end

    test "should return error when category is invalid" do
      {:ok, author} = Library.Author.create_author(%{name: "Autor"})

      {status, _} =
        Library.Book.create_book(%{
          title: "Nome do livro",
          isbn: "0-6672-2445-9",
          price: 123,
          author_id: author.id,
          category_id: 0
        })

      assert status == :error
    end

    test "should return error when author is invalid" do
      {:ok, category} = Library.Category.create_category(%{name: "Categoria"})

      {status, _} =
        Library.Book.create_book(%{
          title: "Nome do livro",
          isbn: "0-6672-2445-9",
          price: 1232,
          author_id: 0,
          category_id: category.id
        })

      assert status == :error
    end
  end

  describe "get_all" do
    test "should return empty list when there is no book" do
      res = Library.Book.get_all()

      assert length(res) == 0
    end

    test "should get all books" do
      {:ok, category} = Library.Category.create_category(%{name: "Categoria"})
      {:ok, author} = Library.Author.create_author(%{name: "Autor"})

      Library.Book.create_book(%{
        title: "teste",
        isbn: "0-6672-2445-9",
        price: 1234,
        author_id: author.id,
        category_id: category.id
      })

      Library.Book.create_book(%{
        title: "teste2",
        isbn: "1-6672-2445-9",
        price: 1234,
        author_id: author.id,
        category_id: category.id
      })

      res = Library.Book.get_all()

      assert length(res) == 2
      assert Enum.any?(res, fn item -> item.title == "teste" end)
      assert Enum.any?(res, fn item -> item.title == "teste2" end)
    end
  end
end
