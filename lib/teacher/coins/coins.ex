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


end
