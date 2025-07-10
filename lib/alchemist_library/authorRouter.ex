defmodule AlchemistLibrary.AuthorRouter do
  use Plug.Router
  use Plug.ErrorHandler

  plug(:match)
  plug(Plug.Parsers, parsers: [:urlencoded, :multipart, :json], json_decoder: Jason)
  plug(:dispatch)

  post "/add" do
    %{"name" => name} = conn.body_params

    case Library.Author.create_author(%{name: name}) do
      {:ok, author} ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(200, Jason.encode!(author))

      {:error, reason} ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(400, Jason.encode!(%{error: reason}))
    end
  end

  get "/get" do
    %{"name" => name} = conn.params

    author = Jason.encode!(Library.Author.get_by_name(name))

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, author)
  end

  get "/get_all" do
    authors = Jason.encode!(Library.Author.get_all())

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, authors)
  end

  put "/change" do
    %{"id" => id, "name" => name} = conn.body_params

    case Library.Author.update_author(id, %{name: name}) do
      {:ok, author} ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(200, Jason.encode!(author))

      {:error, :not_found} ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(404, Jason.encode!(%{error: "Author not found"}))

      {:error, changeset} ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(422, Jason.encode!(%{error: "Update failed", details: changeset}))
    end
  end

  delete "/remove" do
    %{"name" => name} = conn.params

    case Library.Author.delete_author_by_name(name) do
      {:ok, author} ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(200, Jason.encode!(author))

      {:error, :not_found} ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(404, Jason.encode!(%{error: "Author not found"}))

      {:error, changeset} ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(422, Jason.encode!(%{error: "Deletion failed", details: changeset}))
    end
  end
end
