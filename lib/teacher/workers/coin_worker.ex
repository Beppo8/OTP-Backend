defmodule Teacher.Workers.CoinWorker do
  use GenServer

  def start_link(_state) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def add_coin(coin) do
    GenServer.cast(__MODULE__, {:add_coin, coin})
  end

  def init(state) do
    {:ok, state}
  end

  def handle_cast({:add_coin, coin}, state) do
    {:noreply, [coin | state]}
  end

end
