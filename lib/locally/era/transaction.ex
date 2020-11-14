defmodule Locally.Era.Transaction do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "transactions" do
    field :content, :map
    field :h3index, :string
    field :name, :string
    field :status, :string
    field :type, :string
    field :creator_id, :binary_id
    many_to_many :inputs, Locally.Era.Entity,
      join_through: "transaction_inputs"

    timestamps()
  end

  @doc false
  def changeset(transaction, attrs) do
    transaction
    |> cast(attrs, [:h3index, :name, :type, :status, :content])
    |> validate_required([:h3index, :name, :type, :status, :content])
  end
end
