defmodule AlchemistLibrary.FaultyRouter do
  use Plug.Router

  plug(:match)
  plug(:dispatch)

  get "/boom" do
    raise "Intentional error"
  end
end

defmodule AlchemistLibrary.RouterTest do
  use ExUnit.Case, async: true
  import Plug.Test

  @moduletag :router

  @opts AlchemistLibrary.Router.init([])

  describe "router" do
    test "returns 404 for unknown route" do
      conn =
        conn(:get, "/api/unknown")
        |> AlchemistLibrary.Router.call(@opts)

      assert conn.status == 404
      assert conn.resp_body == "Invalid Route"
    end
  end
end
