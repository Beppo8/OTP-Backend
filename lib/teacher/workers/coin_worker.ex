defmodule Teacher.Workers.CoinWorker do
  use GenServer

  def start_link(_state) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def add_coin(coin) do
    GenServer.cast(__MODULE__, {:add_coin, coin})
  end

  def all_coins do
    GenServer.call(__MODULE__, :all_coins)
  end

  def init(state) do
    {:ok, state}
  end

  def handle_cast({:add_coin, coin}, state) do
    {:noreply, [coin | state]}
  end

  def handle_call(:all_coins, _from, state) do
    {:reply, state, state}
  end

end
