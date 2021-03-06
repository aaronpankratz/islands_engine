defmodule GuessesTest do
  use ExUnit.Case
  alias IslandsEngine.{Coordinate, Guesses}

  test "creates guesses" do
    guesses = Guesses.new()
    assert MapSet.size(guesses.hits) == 0
    assert MapSet.size(guesses.misses) == 0
  end

  test "adds hit coordinates" do
    guesses = Guesses.new()
    {:ok, coord1} = Coordinate.new(1, 1)
    guesses = Guesses.add(guesses, :hit, coord1)
    assert MapSet.size(guesses.hits) == 1
  end

  test "adds miss coordinates" do
    guesses = Guesses.new()
    {:ok, coord1} = Coordinate.new(1, 1)
    guesses = Guesses.add(guesses, :miss, coord1)
    assert MapSet.size(guesses.misses) == 1
  end

  test "does not duplicate coordinates" do
    guesses = Guesses.new()
    {:ok, coord1} = Coordinate.new(1, 1)
    guesses = Guesses.add(guesses, :hit, coord1)
    assert MapSet.size(guesses.hits) == 1
    guesses = Guesses.add(guesses, :hit, coord1)
    assert MapSet.size(guesses.hits) == 1 
  end
end
