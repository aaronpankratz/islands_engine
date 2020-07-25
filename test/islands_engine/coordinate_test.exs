defmodule CoordinateTest do
  use ExUnit.Case
  alias IslandsEngine.Coordinate

  test "creates coordinates" do
    {:ok, coordinate} = Coordinate.new(1,1)
    assert coordinate.row == 1
    assert coordinate.col == 1
  end

  test "error for invalid coordinate" do
    {:error, message} = Coordinate.new(-1,-1)
    assert message == :invalid_coordinate
  end
end
