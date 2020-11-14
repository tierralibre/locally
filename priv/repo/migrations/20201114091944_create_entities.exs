defmodule Locally.Repo.Migrations.CreateEntities do
  use Ecto.Migration

  def change do
    create table(:entities, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :h3index, :h3index
      add :name, :string
      add :type, :string
      add :status, :string
      add :topics, {:array, :string}
      add :content, :map
      add :creator_id, references(:users, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    create index(:entities, [:creator_id])
  end
end
