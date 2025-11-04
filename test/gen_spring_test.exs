defmodule GenSpringTest do
  use ExUnit.Case
  doctest GenSpring

  test "greets the world" do
    assert GenSpring.hello() == :world
  end
end
