defmodule AlchemistLibrary.JsonResponse do
  import Plug.Conn

  def send(conn, status, data) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(status, Jason.encode!(data))
  end
end
