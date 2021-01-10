defmodule Teacher.Repo.Migrations.CreateCryptocurrencies do
  use Ecto.Migration

  def change do
    create table(:cryptocurrencies) do
      add :name, :string
      add :price, :float

      timestamps()
    end

    # create unique_index(:cryptocurrencies, [:name])
    create index(:cryptocurrencies, ["lower(name)"],
              name: :cryptocurrencies_name_index,
              unique: true)
  end
end
