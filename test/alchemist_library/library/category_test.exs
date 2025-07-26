defmodule Library.CategoryTest do
  use ExUnit.Case
  use AlchemistLibrary.RepoCase

  setup do
    AlchemistLibrary.Cache.flush()
    :ok
  end

  describe "create_category/1" do
    test "should create category when all atrributes are valid" do
      {status, response} = AlchemistLibrary.Library.Category.create_category(%{name: "Teste"})

      assert status == :ok
      assert response.name == "Teste"
    end

    test "should return error when name is invalid" do
      {status, _} = AlchemistLibrary.Library.Category.create_category(%{name: ""})

      assert status == :error
    end

    test "should not allow duplicate names" do
      AlchemistLibrary.Library.Category.create_category(%{name: "Teste"})
      {status, _} = AlchemistLibrary.Library.Category.create_category(%{name: "Teste"})

      assert status == :error
    end
  end

  describe "get_all" do
    test "should return empty list when there is no category" do
      res = AlchemistLibrary.Library.Category.get_all()

      assert length(res) == 0
    end

    test "should get all categories" do
      AlchemistLibrary.Repo.query!(
        "insert into categories (name, inserted_at, updated_at) values ('teste', now(), now())"
      )

      AlchemistLibrary.Repo.query!(
        "insert into categories (name, inserted_at, updated_at) values ('teste2', now(), now())"
      )

      res = AlchemistLibrary.Library.Category.get_all()

      assert length(res) == 2
      assert Enum.any?(res, fn item -> item.name == "teste" end)
      assert Enum.any?(res, fn item -> item.name == "teste2" end)
    end
  end

  describe "get_by_name/1" do
    test "should return category when it exists" do
      AlchemistLibrary.Repo.query!(
        "insert into categories (name, inserted_at, updated_at) values ('teste', now(), now())"
      )

      res = AlchemistLibrary.Library.Category.get_by_name("teste")

      assert res.name == "teste"
    end

    test "should return nil when category does not exists" do
      res = AlchemistLibrary.Library.Category.get_by_name("novo teste")

      assert res == nil
    end
  end

  describe "update_category/2" do
    test "should return error when category does not exist" do
      res = AlchemistLibrary.Library.Category.update_category(-1, %{name: "Teste"})

      assert res == {:error, :not_found}
    end

    test "should return error when params are invalid" do
      {:ok, category} = AlchemistLibrary.Library.Category.create_category(%{name: "Teste"})
      {status, res} = AlchemistLibrary.Library.Category.update_category(category.id, %{name: ""})

      assert status == :error
      assert res.valid? == false
    end

    test "should update category's name" do
      {:ok, category} = AlchemistLibrary.Library.Category.create_category(%{name: "Teste"})

      {status, res} =
        AlchemistLibrary.Library.Category.update_category(category.id, %{name: "Novo Teste"})

      assert status == :ok
      assert res.name == "Novo Teste"
    end
  end

  describe "delete_category/1" do
    test "should return error when category does not exists" do
      {status, res} = AlchemistLibrary.Library.Category.delete_category(0)

      assert status == :error
      assert res == :not_found
    end

    test "should delete category when it exists" do
      {:ok, category} = AlchemistLibrary.Library.Category.create_category(%{name: "Teste"})
      {status, res} = AlchemistLibrary.Library.Category.delete_category(category.id)
      all_categories = AlchemistLibrary.Library.Category.get_all()

      assert status == :ok
      assert res.name == "Teste"
      assert length(all_categories) == 0
    end
  end

  describe "delete_category_by_name/1" do
    test "should return error when category name does not exists" do
      {status, res} = AlchemistLibrary.Library.Category.delete_category_by_name("Nome fictício")

      assert status == :error
      assert res == :not_found
    end

    test "should delete category when its name exists" do
      AlchemistLibrary.Library.Category.create_category(%{name: "Teste de remoção"})

      {status, res} =
        AlchemistLibrary.Library.Category.delete_category_by_name("Teste de remoção")

      all_categories = AlchemistLibrary.Library.Category.get_all()

      assert status == :ok
      assert res.name == "Teste de remoção"
      assert length(all_categories) == 0
    end
  end
end
