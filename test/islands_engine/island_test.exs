defmodule IslandTest do
  use ExUnit.Case
  alias IslandsEngine.{Coordinate, Island}
  
  test "creates islands" do
    {:ok, coord} = Coordinate.new(4, 6)
    {:ok, island} = Island.new(:l_shape, coord)
    assert MapSet.size(island.coordinates) == 4
  end

  test "error for invalid island type" do
    {:ok, coord} = Coordinate.new(4, 6)
    {:error, message} = Island.new(:wrong, coord)
    assert message == :invalid_island_type
  end

  test "error for invalid coordinate" do
    {:ok, coord} = Coordinate.new(10, 10)
    {:error, message} = Island.new(:l_shape, coord)
    assert message == :invalid_coordinate
 
  end
end
