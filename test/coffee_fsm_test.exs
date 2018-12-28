defmodule CoffeeFsmTest do
  use ExUnit.Case
  doctest CoffeeFsm

  test "greets the world" do
    assert CoffeeFsm.hello() == :world
  end
end
