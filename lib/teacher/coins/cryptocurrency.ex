defmodule Teacher.Coins.Cryptocurrency do
  use Ecto.Schema
  import Ecto.Changeset


  schema "cryptocurrencies" do
    field :name, :string
    field :price, :float

    timestamps()
  end

  @doc false
  def changeset(cryptocurrency, attrs) do
    cryptocurrency
    |> cast(attrs, [:name, :price])
    |> validate_required([:name, :price])
    |> unique_constraint(:name)
  end
end
