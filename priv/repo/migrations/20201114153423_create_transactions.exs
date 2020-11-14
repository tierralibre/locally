defmodule Locally.Repo.Migrations.CreateTransactions do
  use Ecto.Migration

  def change do
    create table(:transactions, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :h3index, :h3index
      add :name, :string
      add :type, :string
      add :status, :string
      add :content, :map
      add :creator_id, references(:users, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    create index(:transactions, [:creator_id])
  end
end
