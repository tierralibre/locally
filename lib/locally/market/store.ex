defmodule Locally.Market.Store do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false

  embedded_schema do
    field :uuid, :string
    field :name, :string
    field :postal_code, :string
    field :postal_direction, :string
    field :owner_id, :binary_id
  end

  @doc false
  def changeset(store, attrs) do
    store
    |> cast(attrs, [:name, :postal_code, :postal_direction])
    |> validate_required([:name, :postal_code, :postal_direction])
  end

  def to_store(data, uuid) do
    struct(__MODULE__, Map.put(data, :uuid, uuid))
  end
end
