defmodule BoardTest do
  use ExUnit.Case
  alias IslandsEngine.{Board, Coordinate, Island}

  test "creates board" do
    board = Board.new()
    assert board == %{}
  end

  test "position island" do
    board = Board.new()
    {:ok, square_coordinate} = Coordinate.new(1, 1)
    {:ok, square} = Island.new(:square, square_coordinate)
    board = Board.position_island(board, :square, square)
    assert board[:square] == square
  end

  test "error when overlap" do
    board = Board.new()
    {:ok, square_coordinate} = Coordinate.new(1, 1)
    {:ok, square} = Island.new(:square, square_coordinate)
    board = Board.position_island(board, :square, square)
    {:ok, dot_coordinate} = Coordinate.new(2, 2)
    {:ok, dot} = Island.new(:dot, dot_coordinate)
    {:error, message} = Board.position_island(board, :dot, dot)
    assert message == :overlapping_island
  end

  test "guess when miss" do
    board = Board.new()
    {:ok, square_coordinate} = Coordinate.new(1, 1)
    {:ok, square} = Island.new(:square, square_coordinate)
    board = Board.position_island(board, :square, square)
    {:ok, guess_coordinate} = Coordinate.new(10, 10)
    {:miss, :none, :no_win, board} = Board.guess(board, guess_coordinate)
    assert MapSet.size(board[:square].hit_coordinates) == 0
  end

  test "guess when hit" do
    board = Board.new()
    {:ok, square_coordinate} = Coordinate.new(1, 1)
    {:ok, square} = Island.new(:square, square_coordinate)
    board = Board.position_island(board, :square, square)
    {:ok, guess_coordinate} = Coordinate.new(1, 1)
    {:hit, :none, :no_win, board} = Board.guess(board, guess_coordinate)
    assert MapSet.size(board[:square].hit_coordinates) == 1
  end

  test "guess when win" do
    board = Board.new()
    {:ok, dot_coordinate} = Coordinate.new(1, 1)
    {:ok, dot} = Island.new(:dot, dot_coordinate)
    board = Board.position_island(board, :dot, dot)
    {:ok, guess_coordinate} = Coordinate.new(1, 1)
    {:hit, :dot, :win, board} = Board.guess(board, guess_coordinate)
    assert MapSet.size(board[:dot].hit_coordinates) == 1
  end
end
