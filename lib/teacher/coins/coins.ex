defmodule Teacher.Coins do

  alias Teacher.Repo
  alias Teacher.Coins.{CoinService, Cryptocurrency}
  alias Teacher.Workers.CoinWorker

  def list_coins do
    Repo.all(Cryptocurrency)
  end

  def track_coin(name) do
    with {:ok, price} <- CoinService.fetch_current_price(name),
         {:ok, cryptocurrency} <- insert_coin(%{"name" => name, "price" => price}) do
      CoinWorker.add_coin(cryptocurrency)
      {:ok, cryptocurrency.price}
      else
        {:error, %Ecto.Changeset{} = changeset} ->
          {:error, changeset}

        {:error, msg} ->
          %Cryptocurrency{}
          |> change_cryptocurrency(%{"name" => name})
          |> Ecto.Changeset.add_error(:name, msg)
          |> Ecto.Changeset.apply_action(:insert)
      end
  end

  def change_cryptocurrency(%Cryptocurrency{} = cryptocurrency, attrs \\ %{}) do
    Cryptocurrency.changeset(cryptocurrency, attrs)
  end

  def insert_coin(attrs) do
    %Cryptocurrency{}
    |> Cryptocurrency.changeset(attrs)
    |> Repo.insert()
  end

  def tracked_coins do
    CoinWorker.all_coins()
  end

  def update_price(coin) do
    with {:ok, price} <- CoinService.fetch_current_price(coin.name),
         {:ok, updated_coin} <- update_cryptocurrency(coin, %{"price" => price}) do
      updated_coin
    else
      {:error, _} ->
        coin
    end
    # case CoinService.fetch_current_price(coin.name) do
    #   {:ok, price} ->
    #     %{coin | price: price}
    #   {:error, _msg} ->
    #       coin
    # end
  end

  def update_cryptocurrency(%Cryptocurrency{} = cryptocurrency, attrs) do
    cryptocurrency
    |> Cryptocurrency.changeset(attrs)
    |> Repo.update()
  end

end
