defmodule AlchemistLibrary.CategoryRouter do
  use Plug.Router
  use Plug.ErrorHandler

  plug(:match)
  plug(Plug.Parsers, parsers: [:urlencoded, :multipart, :json], json_decoder: Jason)
  plug(:dispatch)

  post "/add" do
    AlchemistLibrary.CategoryController.create(conn, conn.body_params)
  end

  get "/get" do
    AlchemistLibrary.CategoryController.read(conn, conn.params)
  end

  get "/get_all" do
    AlchemistLibrary.CategoryController.read_all(conn)
  end

  put "/change" do
    AlchemistLibrary.CategoryController.update(conn, conn.body_params)
  end

  delete "/remove" do
    AlchemistLibrary.CategoryController.delete(conn, conn.params)
  end
end
