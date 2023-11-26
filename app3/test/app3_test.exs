defmodule App3Test do
  use ExUnit.Case
  doctest App3

  test "greets the world" do
    assert App3.hello() == :world
  end
end
