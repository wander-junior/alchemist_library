defmodule AlchemistLibraryTest do
  use ExUnit.Case
  doctest AlchemistLibrary

  test "greets the world" do
    assert AlchemistLibrary.hello() == :world
  end
end
