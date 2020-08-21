defmodule RulesTest do
  use ExUnit.Case
  alias IslandsEngine.Rules

  test "starts in initialized state" do
    rules = Rules.new()
    assert rules.state == :initialized
  end

  test "error when unexpected action" do
    rules = Rules.new()
    result = Rules.check(rules, :wrong)
    assert result == :error
  end

  test "players_set when add_players from initialized" do
    rules = Rules.new()
    {:ok, rules} = Rules.check(rules, :add_player)
    assert rules.state == :players_set
  end

  test "players_set when position_islands from players_set" do
    rules = Rules.new()
    rules = %{rules | state: :players_set}
    {:ok, rules} = Rules.check(rules, {:position_islands, :player1})
    {:ok, rules} = Rules.check(rules, {:position_islands, :player2})
    assert rules.state == :players_set
  end

  test "players_set when set_islands from players_set" do
    rules = Rules.new()
    rules = %{rules | state: :players_set}
    {:ok, rules} = Rules.check(rules, {:set_islands, :player1})
    assert rules.state == :players_set
  end

  test "remains players_set when set_islands when only 1 player set_islands" do
    rules = Rules.new()
    rules = %{rules | state: :players_set}
    {:ok, rules} = Rules.check(rules, {:set_islands, :player1})
    {:ok, rules} = Rules.check(rules, {:set_islands, :player1})
    assert rules.state == :players_set
  end

  test "error when position_islands after set_islands" do
    rules = Rules.new()
    rules = %{rules | state: :players_set}
    {:ok, rules} = Rules.check(rules, {:set_islands, :player1})
    result = Rules.check(rules, {:position_islands, :player1})
    assert result == :error
  end

  test "unset player can continue to position islands" do
    rules = Rules.new()
    rules = %{rules | state: :players_set}
    {:ok, rules} = Rules.check(rules, {:set_islands, :player1})
    {:ok, rules} = Rules.check(rules, {:position_islands, :player2})
    assert rules.state == :players_set
  end

  test "player1_turn after both players set islands" do
    rules = Rules.new()
    rules = %{rules | state: :players_set}
    {:ok, rules} = Rules.check(rules, {:set_islands, :player1})
    {:ok, rules} = Rules.check(rules, {:set_islands, :player2})
    assert rules.state == :player1_turn
  end

  test "player2 cannot guess coordinate when player1_turn" do
    rules = Rules.new()
    rules = %{rules | state: :player1_turn}
    result = Rules.check(rules, {:guess_coordinate, :player2})
    assert result == :error
  end

  test "player2_turn after player1 guesses coordinate" do
    rules = Rules.new()
    rules = %{rules | state: :player1_turn}
    {:ok, rules} = Rules.check(rules, {:guess_coordinate, :player1})
    assert rules.state == :player2_turn
  end

  test "remains player1 turn when no win" do
    rules = Rules.new()
    rules = %{rules | state: :player1_turn}
    {:ok, rules} = Rules.check(rules, {:win_check, :no_win})
    assert rules.state == :player1_turn
  end

  test "remains player2 turn when no win" do
    rules = Rules.new()
    rules = %{rules | state: :player2_turn}
    {:ok, rules} = Rules.check(rules, {:win_check, :no_win})
    assert rules.state == :player2_turn
  end

  test "game_over when player1 wins" do
    rules = Rules.new()
    rules = %{rules | state: :player1_turn}
    {:ok, rules} = Rules.check(rules, {:win_check, :win})
    assert rules.state == :game_over
  end

  test "game_over when player2 wins" do
    rules = Rules.new()
    rules = %{rules | state: :player2_turn}
    {:ok, rules} = Rules.check(rules, {:win_check, :win})
    assert rules.state == :game_over
  end

end
