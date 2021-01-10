defmodule Teacher.Coins do

  alias Teacher.Coins.CoinService
  alias Teacher.Workers.CoinWorker

  def add_coin(name) do
    case CoinService.fetch_current_price(name) do
      {:ok, price} ->
        CoinWorker.add_coin(%{name: name, price: price})
        {:ok, price}
      {:error, msg} ->
        {:error, msg}
    end
  end

  def all_coins do
    CoinWorker.all_coins()
  end

  def update_price(coin) do
    case CoinService.fetch_current_price(coin.name) do
      {:ok, price} ->
        %{coin | price: price}
      {:error, _msg} ->
          coin
    end
  end

end
