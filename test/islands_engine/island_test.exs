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

  test "detects overlaps" do
    {:ok, square_coordinate} = Coordinate.new(1, 1)
    {:ok, square} = Island.new(:square, square_coordinate)
    {:ok, dot_coordinate} = Coordinate.new(1, 2)
    {:ok, dot} = Island.new(:dot, dot_coordinate)
    {:ok, l_shape_coordinate} = Coordinate.new(5, 5)
    {:ok, l_shape} = Island.new(:l_shape, l_shape_coordinate)
    assert Island.overlaps?(square, dot)
    assert not Island.overlaps?(square, l_shape)
    assert not Island.overlaps?(dot, l_shape)
  end

  test "guess miss" do
    {:ok, dot_coordinate} = Coordinate.new(4, 4)
    {:ok, dot} = Island.new(:dot, dot_coordinate)
    {:ok, guess_coordinate} = Coordinate.new(2, 2)
    result = Island.guess(dot, guess_coordinate)
    assert result == :miss
  end

  test "guess hit" do
    {:ok, dot_coordinate} = Coordinate.new(4, 4)
    {:ok, dot} = Island.new(:dot, dot_coordinate)
    {:ok, guess_coordinate} = Coordinate.new(4, 4)
    {:hit, result} = Island.guess(dot, guess_coordinate)
    assert MapSet.size(result.hit_coordinates) == 1
  end

  test "detects forested" do
    {:ok, dot_coordinate} = Coordinate.new(4, 4)
    {:ok, dot} = Island.new(:dot, dot_coordinate)
    {:ok, guess_coordinate} = Coordinate.new(4, 4)
    {:hit, result} = Island.guess(dot, guess_coordinate)
    assert Island.forested?(result)
  end
end
