defmodule Teacher.Coins.CoinService do

  def fetch_current_price(id) do
    case fetch_coin(id) do
      nil ->
        {:error, "No coin found"}
      price ->
        {:ok, String.to_float(price)}
    end
  end

  defp fetch_coin(ticker) do
    ticker
    |> String.downcase()
    |> url()
    |> HTTPoison.get!()
    |> Map.get(:body)
    |> Jason.decode!()
    |> get_in(["data", "priceUsd"])
  end

  defp url(ticker) do
    "https://api.coincap.io/v2/assets/#{ticker}"
  end

end
