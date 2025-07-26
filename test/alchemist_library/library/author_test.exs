defmodule AlchemistLibrary.Library.AuthorTest do
  alias AlchemistLibrary.Library.Author
  alias AlchemistLibrary.Repo

  use ExUnit.Case
  use AlchemistLibrary.RepoCase

  describe "create_author/1" do
    test "should create author when all atrributes are valid" do
      {status, response} = Author.create_author(%{name: "Teste"})

      assert status == :ok
      assert response.name == "Teste"
    end

    test "should return error when name is invalid" do
      {status, _} = Author.create_author(%{name: ""})

      assert status == :error
    end

    test "should not allow duplicate names" do
      Author.create_author(%{name: "Teste"})
      {status, _} = Author.create_author(%{name: "Teste"})

      assert status == :error
    end
  end

  describe "get_all" do
    test "should return empty list when there is no author" do
      res = Author.get_all()

      assert length(res) == 0
    end

    test "should get all authors" do
      Repo.query!(
        "insert into authors (name, inserted_at, updated_at) values ('teste', now(), now())"
      )

      Repo.query!(
        "insert into authors (name, inserted_at, updated_at) values ('teste2', now(), now())"
      )

      res = Author.get_all()

      assert length(res) == 2
      assert Enum.any?(res, fn item -> item.name == "teste" end)
      assert Enum.any?(res, fn item -> item.name == "teste2" end)
    end
  end

  describe "get_by_name/1" do
    test "should return author when it exists" do
      Repo.query!(
        "insert into authors (name, inserted_at, updated_at) values ('teste', now(), now())"
      )

      res = Author.get_by_name("teste")

      assert res.name == "teste"
    end

    test "should return nil when author does not exists" do
      res = Author.get_by_name("novo teste")

      assert res == nil
    end
  end

  describe "update_author/2" do
    test "should return error when author does not exist" do
      res = Author.update_author(-1, %{name: "Teste"})

      assert res == {:error, :not_found}
    end

    test "should return error when params are invalid" do
      {:ok, author} = Author.create_author(%{name: "Fulano da Silva"})
      {status, res} = Author.update_author(author.id, %{name: ""})

      assert status == :error
      assert res.valid? == false
    end

    test "should update author's name" do
      {:ok, author} = Author.create_author(%{name: "Fulano da Silva"})
      {status, res} = Author.update_author(author.id, %{name: "Beltrano da Fonseca"})

      assert status == :ok
      assert res.name == "Beltrano da Fonseca"
    end
  end

  describe "delete_author/1" do
    test "should return error when author does not exists" do
      {status, res} = Author.delete_author(0)

      assert status == :error
      assert res == :not_found
    end

    test "should delete author when it exists" do
      {:ok, author} = Author.create_author(%{name: "Fulano da Silva"})
      {status, res} = Author.delete_author(author.id)
      all_authors = Author.get_all()

      assert status == :ok
      assert res.name == "Fulano da Silva"
      assert length(all_authors) == 0
    end
  end

  describe "delete_author_by_name/1" do
    test "should return error when author name does not exists" do
      {status, res} = Author.delete_author_by_name("Nome fictício")

      assert status == :error
      assert res == :not_found
    end

    test "should delete author when its name exists" do
      Author.create_author(%{name: "Teste de remoção"})
      {status, res} = Author.delete_author_by_name("Teste de remoção")
      all_categories = Author.get_all()

      assert status == :ok
      assert res.name == "Teste de remoção"
      assert length(all_categories) == 0
    end
  end
end
