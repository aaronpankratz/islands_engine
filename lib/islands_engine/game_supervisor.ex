defmodule IslandsEngine.GameSupervisor do
  use DynamicSupervisor 

  alias IslandsEngine.Game

  def start_link(_options), do:
    DynamicSupervisor.start_link(__MODULE__, :ok, name: __MODULE__)

  def start_game(name) do
    spec = %{id: name, start: {Game, :start_link, [name]}}
    DynamicSupervisor.start_child(__MODULE__, spec)
  end

  def stop_game(name) do
    :dets.delete(:game_state, name)
    DynamicSupervisor.terminate_child(__MODULE__, pid_from_name(name))
  end

  def init(:ok), do:
    DynamicSupervisor.init(strategy: :one_for_one)

  defp pid_from_name(name) do
    name
    |> Game.via_tuple()
    |> GenServer.whereis()
  end
end

