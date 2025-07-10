defmodule AlchemistLibrary.BookRouter do
  use Plug.Router
  use Plug.ErrorHandler

  plug(:match)
  plug(Plug.Parsers, parsers: [:urlencoded, :multipart, :json], json_decoder: Jason)
  plug(:dispatch)

  post "/add" do
    case Library.Book.create_book(conn.body_params) do
      {:ok, book} ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(200, Jason.encode!(book))

      {:error, reason} ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(400, Jason.encode!(%{error: reason}))
    end
  end

  get "/get" do
    %{"title" => title} = conn.params

    author = Jason.encode!(Library.Book.get_by_title(title))

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, author)
  end

  get "/get_all" do
    filters =
      conn.params
      |> build_price_filters()

    books =
      Library.Book.get_all(filters)
      |> Jason.encode!()

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, books)
  end

  get "/get_by_authors_name" do
    filters =
      conn.params
      |> build_price_filters()

    %{"name" => name} = conn.params

    books =
      Jason.encode!(Library.Book.get_by_authors_name(name, filters))

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, books)
  end

  get "/get_by_category_name" do
    filters =
      conn.params
      |> build_price_filters()

    %{"category" => category} = conn.params

    books =
      Jason.encode!(Library.Book.get_by_category_name(category, filters))

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, books)
  end

  put "/change" do
    %{
      "id" => id,
      "title" => title,
      "isbn" => isbn,
      "price" => price,
      "author_id" => author_id,
      "category_id" => category_id
    } =
      conn.body_params

    case Library.Book.update_book(id, %{
           title: title,
           isbn: isbn,
           price: price,
           author_id: author_id,
           category_id: category_id
         }) do
      {:ok, book} ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(200, Jason.encode!(book))

      {:error, :not_found} ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(404, Jason.encode!(%{error: "Book not found"}))

      {:error, changeset} ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(422, Jason.encode!(%{error: "Update failed", details: changeset}))
    end
  end

  delete "/remove" do
    %{"id" => id} = conn.params

    case Library.Book.delete_book(id) do
      {:ok, book} ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(200, Jason.encode!(book))

      {:error, :not_found} ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(404, Jason.encode!(%{error: "Book not found"}))

      {:error, changeset} ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(422, Jason.encode!(%{error: "Deletion failed", details: changeset}))
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
