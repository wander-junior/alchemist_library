defmodule AlchemistLibrary.AuthorController do
  alias AlchemistLibrary.JsonResponse
  alias AlchemistLibrary.Library.Author

  def create(conn, %{"name" => name}) do
    case Author.create_author(%{name: name}) do
      {:ok, author} -> JsonResponse.send(conn, 201, author)
      {:error, reason} -> JsonResponse.send(conn, 400, %{error: reason})
    end
  end

  def read(conn, %{"name" => name}) do
    case Author.get_by_name(name) do
      nil ->
        JsonResponse.send(conn, 404, %{error: "Author not found"})

      result ->
        JsonResponse.send(conn, 200, result)
    end
  end

  def readAll(conn) do
    authors = Author.get_all()

    JsonResponse.send(conn, 200, authors)
  end

  def update(conn, %{"id" => id, "name" => name}) do
    case Author.update_author(id, %{name: name}) do
      {:ok, author} ->
        JsonResponse.send(conn, 200, author)

      {:error, :not_found} ->
        JsonResponse.send(conn, 404, %{error: "Author not found"})

      {:error, changeset} ->
        JsonResponse.send(conn, 422, %{error: "Update failed", details: changeset})
    end
  end

  def delete(conn, %{"name" => name}) do
    case Author.delete_author_by_name(name) do
      {:ok, author} ->
        JsonResponse.send(conn, 200, author)

      {:error, :not_found} ->
        JsonResponse.send(conn, 404, %{error: "Author not found"})

      {:error, changeset} ->
        JsonResponse.send(conn, 422, %{error: "Deletion failed", details: changeset})
    end
  end
end
