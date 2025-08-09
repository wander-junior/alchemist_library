defmodule AlchemistLibrary.BookController do
  alias AlchemistLibrary.JsonResponse
  alias AlchemistLibrary.Library.Book

  def create(conn, body_params) do
    case Book.create_book(body_params) do
      {:ok, book} -> JsonResponse.send(conn, 201, book)
      {:error, reason} -> JsonResponse.send(conn, 400, %{error: reason})
    end
  end

  def read(conn, %{"title" => title}) do
    case Book.get_by_title(title) do
      nil ->
        JsonResponse.send(conn, 404, %{error: "Book not found"})

      result ->
        JsonResponse.send(conn, 200, result)
    end
  end

  def readAll(conn) do
    filters =
      conn.params
      |> build_price_filters()

    books =
      Book.get_all(filters)

    JsonResponse.send(conn, 200, books)
  end

  def readByAuthorName(conn, params) do
    filters =
      params
      |> build_price_filters()

    books =
      Book.get_by_authors_name(params["name"], filters)

    JsonResponse.send(conn, 200, books)
  end

  def readByCategoryName(conn, params) do
    filters =
      params
      |> build_price_filters()

    books =
      Jason.encode!(Book.get_by_category_name(params.category, filters))

    JsonResponse.send(conn, 200, books)
  end

  def update(conn, body_params) do
    %{
      "id" => id,
      "title" => title,
      "isbn" => isbn,
      "price" => price,
      "author_id" => author_id,
      "category_id" => category_id
    } =
      body_params

    case Book.update_book(id, %{
           title: title,
           isbn: isbn,
           price: price,
           author_id: author_id,
           category_id: category_id
         }) do
      {:ok, book} ->
        JsonResponse.send(conn, 200, book)

      {:error, :not_found} ->
        JsonResponse.send(conn, 404, %{error: "Author not found"})

      {:error, changeset} ->
        JsonResponse.send(conn, 422, %{error: "Update failed", details: changeset})
    end
  end

  def remove(conn, %{"id" => id}) do
    case Book.delete_book(id) do
      {:ok, book} ->
        JsonResponse.send(conn, 200, book)

      {:error, :not_found} ->
        JsonResponse.send(conn, 404, %{error: "Book not found"})

      {:error, changeset} ->
        JsonResponse.send(conn, 422, %{error: "Deletion failed", details: changeset})
    end
  end

  defp build_price_filters(params) do
    %{}
    |> maybe_put_int(:min_price, params["min_price"])
    |> maybe_put_int(:max_price, params["max_price"])
  end

  defp maybe_put_int(map, _key, nil), do: map

  defp maybe_put_int(map, key, value) do
    case Integer.parse(value) do
      {int, _} -> Map.put(map, key, int)
      :error -> map
    end
  end
end
