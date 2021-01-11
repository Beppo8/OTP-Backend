defmodule TeacherWeb.CoinTrackerChannel do
  use TeacherWeb, :channel

  def join("coin_tracker:", payload, socket) do
    {:ok, socket}
  end

end
