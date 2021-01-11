defmodule Teacher.Workers.CoinWorker do
  use GenServer

  #API
  def start_link(_state) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def add_coin(coin) do
    GenServer.cast(__MODULE__, {:add_coin, coin})
  end

  def all_coins do
    GenServer.call(__MODULE__, :all_coins)
  end

  #CALLBACKS
  def init(state) do
    schedule_coin_refresh()
    {:ok, state, {:continue, :load_coins}}
  end

  def handle_cast({:add_coin, coin}, state) do
    {:noreply, [coin | state]}
  end

  def handle_call(:all_coins, _from, state) do
    {:reply, state, state}
  end

  def handle_info(:update_coins, state) do
    {:noreply, state, {:continue, :get_coin_prices}}
  end

  def handle_continue(:load_coins, _state) do
    coins = Teacher.Coins.list_coins()
    {:noreply, coins}
  end

  def handle_continue(:get_coin_prices,state) do
    updated_coin_prices = update_coin_prices(state)
    schedule_coin_refresh()
    {:noreply, updated_coin_prices}
  end

  defp update_coin_prices(state) do
    state
    |> Task.async_stream(&(Teacher.Coins.update_price(&1)))
    |> Enum.map(fn({:ok, result}) -> result end)
  end

  defp schedule_coin_refresh do
    Process.send_after(self(), :update_coins, 60_000)
  end

end
