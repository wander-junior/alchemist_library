defmodule AlchemistLibrary.CategoryRouter do
  use Plug.Router
  use Plug.ErrorHandler

  plug(:match)
  plug(Plug.Parsers, parsers: [:urlencoded, :multipart, :json], json_decoder: Jason)
  plug(:dispatch)

  post "/add" do
    %{"name" => name} = conn.body_params

    case Library.Category.create_category(%{name: name}) do
      {:ok, category} ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(200, Jason.encode!(category))

      {:error, reason} ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(400, Jason.encode!(%{error: reason}))
    end
  end

  get "/get" do
    %{"name" => name} = conn.params

    key = {:category_by_name, name}

    category =
      case AlchemistLibrary.Cache.get(key) do
        nil ->
          case Library.Category.get_by_name(name) do
            nil ->
              nil

            result ->
              AlchemistLibrary.Cache.put(key, result, ttl: :timer.minutes(10))
              result
          end

        cached_result ->
          cached_result
      end

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Jason.encode!(category))
  end

  get "/get_all" do
    categories = Jason.encode!(Library.Category.get_all())

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, categories)
  end

  put "/change" do
    %{"id" => id, "name" => name} = conn.body_params

    case Library.Category.update_category(id, %{name: name}) do
      {:ok, category} ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(200, Jason.encode!(category))

      {:error, :not_found} ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(404, Jason.encode!(%{error: "Category not found"}))

      {:error, changeset} ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(422, Jason.encode!(%{error: "Update failed", details: changeset}))
    end
  end

  delete "/remove" do
    %{"name" => name} = conn.params

    case Library.Category.delete_category_by_name(name) do
      {:ok, category} ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(200, Jason.encode!(category))

      {:error, :not_found} ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(404, Jason.encode!(%{error: "Category not found"}))

      {:error, changeset} ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(422, Jason.encode!(%{error: "Deletion failed", details: changeset}))
    end
  end
end
