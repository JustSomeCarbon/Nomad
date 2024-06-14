defmodule Nomad do
  @moduledoc """
  Documentation for `Nomad`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Nomad.hello()
      :world

  """
  def start(_type, _args) do
    hello()
    {:ok, self()}
  end


  def hello do
    IO.puts "hello, world!"
  end
end
