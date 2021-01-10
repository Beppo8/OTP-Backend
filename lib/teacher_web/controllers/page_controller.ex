defmodule TeacherWeb.PageController do
  use TeacherWeb, :controller

  alias Teacher.Coins

  def index(conn, _params) do
    coins = Coins.all_coins()
    render(conn, "index.html", coins: coins)
  end

  def create(conn, %{"name" => name}) do
    case Coins.add_coin(name) do
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
