defmodule YatmTest do
  use ExUnit.Case
  doctest Yatm

  test "greets the world" do
    assert Yatm.hello() == :world
  end
end
