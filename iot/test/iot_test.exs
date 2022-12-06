defmodule IotTest do
  use ExUnit.Case
  doctest Iot

  test "greets the world" do
    assert Iot.hello() == :world
  end
end
