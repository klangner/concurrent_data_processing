defmodule FacilityTest do
  use ExUnit.Case
  doctest Facility

  test "greets the world" do
    assert Facility.hello() == :world
  end
end
