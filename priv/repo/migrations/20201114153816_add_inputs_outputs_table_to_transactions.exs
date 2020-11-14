defmodule Locally.Repo.Migrations.AddInputsOutputsTableToTransactions do
  use Ecto.Migration

  def change do
    create table("transaction_inputs", primary_key: false) do
      add :transaction_input_id, references(:transactions, on_delete: :nothing, type: :binary_id)
      add :entity_id, references(:entities, on_delete: :nothing, type: :binary_id)
      # timestamps()
    end
  end
end
