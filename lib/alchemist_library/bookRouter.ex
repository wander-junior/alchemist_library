defmodule AlchemistLibrary.BookRouter do
  use Plug.Router
  use Plug.ErrorHandler

  plug(:match)
  plug(Plug.Parsers, parsers: [:urlencoded, :multipart, :json], json_decoder: Jason)
  plug(:dispatch)

  post "/add" do
    AlchemistLibrary.BookController.create(conn, conn.body_params)
  end

  get "/get" do
    AlchemistLibrary.BookController.read(conn, conn.params)
  end

  get "/get_all" do
    AlchemistLibrary.BookController.readAll(conn)
  end

  get "/get_by_authors_name" do
    AlchemistLibrary.BookController.readByAuthorName(conn, conn.params)
  end

  get "/get_by_category_name" do
    AlchemistLibrary.BookController.readByCategoryName(conn, conn.params)
  end

  put "/change" do
    AlchemistLibrary.BookController.update(conn, conn.params)
  end

  delete "/remove" do
    AlchemistLibrary.BookController.remove(conn, conn.params)
  end
end
