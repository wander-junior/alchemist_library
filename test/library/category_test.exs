defmodule Library.CategoryTest do
  use ExUnit.Case
  use Library.RepoCase

  describe "create_category/1" do
    test "should create category when all atrributes are valid" do
      {status, response} = Library.Category.create_category(%{name: "Teste"})

      assert status == :ok
      assert response.name == "Teste"
    end

    test "should return error when name is invalid" do
      {status, _} = Library.Category.create_category(%{name: ""})

      assert status == :error
    end

    test "should not allow duplicate names" do
      Library.Category.create_category(%{name: "Teste"})
      {status, _} = Library.Category.create_category(%{name: "Teste"})

      assert status == :error
    end
  end

  describe "get_all" do
    test "should return empty list when there is no category" do
      res = Library.Category.get_all()

      assert length(res) == 0
    end

    test "should get all categories" do
      Library.Repo.query!(
        "insert into categories (name, inserted_at, updated_at) values ('teste', now(), now())"
      )

      Library.Repo.query!(
        "insert into categories (name, inserted_at, updated_at) values ('teste2', now(), now())"
      )

      res = Library.Category.get_all()

      assert length(res) == 2
      assert Enum.any?(res, fn item -> item.name == "teste" end)
      assert Enum.any?(res, fn item -> item.name == "teste2" end)
    end
  end

  describe "get_by_name/1" do
    test "should return category when it exists" do
      Library.Repo.query!(
        "insert into categories (name, inserted_at, updated_at) values ('teste', now(), now())"
      )

      res = Library.Category.get_by_name("teste")

      assert res.name == "teste"
    end

    test "should return nil when category does not exists" do
      res = Library.Category.get_by_name("teste")

      assert res == nil
    end
  end

  describe "update_category/2" do
    test "should return error when category does not exist" do
      res = Library.Category.update_category(-1, %{name: "Teste"})

      assert res == {:error, :not_found}
    end

    test "should return error when params are invalid" do
      {:ok, category} = Library.Category.create_category(%{name: "Teste"})
      {status, res} = Library.Category.update_category(category.id, %{name: ""})

      assert status == :error
      assert res.valid? == false
    end

    test "should update category's name" do
      {:ok, category} = Library.Category.create_category(%{name: "Teste"})
      {status, res} = Library.Category.update_category(category.id, %{name: "Novo Teste"})

      assert status == :ok
      assert res.name == "Novo Teste"
    end
  end

  describe "delete_category/1" do
    test "should return error when author does not exists" do
      {status, res} = Library.Category.delete_category(0)

      assert status == :error
      assert res == :not_found
    end

    test "should delete author when it exists" do
      {:ok, category} = Library.Category.create_category(%{name: "Teste"})
      {status, res} = Library.Category.delete_category(category.id)
      all_categories = Library.Category.get_all()

      assert status == :ok
      assert res.name == "Teste"
      assert length(all_categories) == 0
    end
  end
end
