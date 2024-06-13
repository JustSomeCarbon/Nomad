defmodule NomadTest do
  use ExUnit.Case
  doctest Nomad

  test "greets the world" do
    assert Nomad.hello() == :world
  end
end
