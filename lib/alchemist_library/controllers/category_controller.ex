defmodule AlchemistLibrary.CategoryController do
  alias AlchemistLibrary.JsonResponse

  def create(conn, %{"name" => name}) do
    case Library.Category.create_category(%{name: name}) do
      {:ok, category} -> JsonResponse.send(conn, 201, category)
      {:error, reason} -> JsonResponse.send(conn, 400, %{error: reason})
    end
  end

  def read(conn, %{"name" => name}) do
    case Library.Category.get_by_name(name) do
      nil ->
        JsonResponse.send(conn, 404, %{error: "Category not found"})

      result ->
        JsonResponse.send(conn, 200, result)
    end
  end

  def read_all(conn) do
    all_categories = Library.Category.get_all()

    JsonResponse.send(conn, 200, all_categories)
  end

  def update(conn, %{"id" => id, "name" => name}) do
    case Library.Category.update_category(id, %{name: name}) do
      {:ok, category} ->
        JsonResponse.send(conn, 200, category)

      {:error, :not_found} ->
        JsonResponse.send(conn, 404, %{error: "Category not found"})

      {:error, changeset} ->
        JsonResponse.send(conn, 422, %{error: "Update failed", details: changeset})
    end
  end

  def delete(conn, %{"name" => name}) do
    case Library.Category.delete_category_by_name(name) do
      {:ok, category} ->
        JsonResponse.send(conn, 200, category)

      {:error, :not_found} ->
        JsonResponse.send(conn, 404, %{error: "Category not found"})

      {:error, changeset} ->
        JsonResponse.send(conn, 422, %{error: "Deletion failed", details: changeset})
    end
  end
end
