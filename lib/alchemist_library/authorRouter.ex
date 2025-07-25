defmodule AlchemistLibrary.AuthorRouter do
  use Plug.Router
  use Plug.ErrorHandler

  plug(:match)
  plug(Plug.Parsers, parsers: [:urlencoded, :multipart, :json], json_decoder: Jason)
  plug(:dispatch)

  post "/add" do
    AlchemistLibrary.AuthorController.create(conn, conn.body_params)
  end

  get "/get" do
    AlchemistLibrary.AuthorController.read(conn, conn.body_params)
  end

  get "/get_all" do
    AlchemistLibrary.AuthorController.readAll(conn)
  end

  put "/change" do
    AlchemistLibrary.AuthorController.update(conn, conn.body_params)
  end

  delete "/remove" do
    AlchemistLibrary.AuthorController.delete(conn, conn.params)
  end
end
