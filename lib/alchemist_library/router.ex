defmodule AlchemistLibrary.Router do
  use Plug.Router
  use Plug.ErrorHandler

  plug(:match)
  plug(Plug.Parsers, parsers: [:urlencoded, :multipart, :json], json_decoder: Jason)
  plug(:dispatch)

  forward "/api/category", to: AlchemistLibrary.CategoryRouter
  forward "/api/author", to: AlchemistLibrary.AuthorRouter

  match _ do
    send_resp(conn, 404, "Invalid Route")
  end

  def handle_errors(conn, %{kind: kind, reason: reason, stack: stack}) do
    IO.inspect(kind, label: :kind)
    IO.inspect(reason, label: :reason)
    IO.inspect(stack, label: :stack)
    send_resp(conn, conn.status, "Something went wrong")
  end
end
