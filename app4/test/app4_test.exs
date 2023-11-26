defmodule App4Test do
  use ExUnit.Case
  doctest App4

  test "greets the world" do
    assert App4.hello() == :world
  end
end
