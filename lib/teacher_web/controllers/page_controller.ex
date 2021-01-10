defmodule TeacherWeb.PageController do
  use TeacherWeb, :controller

  alias Teacher.Coins
  alias Teacher.Coins.Cryptocurrency

  def index(conn, _params) do
    coins = Coins.tracked_coins()
    changeset = Coins.change_cryptocurrency(%Cryptocurrency{})
    render(conn, "index.html", coins: coins, changeset: changeset)
  end

  def create(conn, %{"name" => name}) do
    case Coins.track_coin(name) do
      {:ok, _price} ->
        conn
        |> put_flash(:info, "Coin added")
        |> redirect(to: "/")

      {:error, msg} ->
        conn
        |> put_flash(:error, msg)
        |> redirect(to: "/")
    end
  end
end
