defmodule Library.CategoryTest do
  use ExUnit.Case

  describe "get_all/0" do
    test "should get all categories" do
      Library.Repo.query!("insert into categories (name, inserted_at, updated_at) values ('teste', now(), now())")

      assert "teste" == Library.Category.get_all()
    end
  end
end
