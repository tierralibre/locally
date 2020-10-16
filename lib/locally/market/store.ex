defmodule Locally.Market.Store do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  @attrs [:id, :name, :postal_code, :postal_direction, :owner_id]

  embedded_schema do
    field :id, :string
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
    %__MODULE__{}
    |> cast(Map.put(data, "id", uuid), @attrs)
    |> apply_changes()
  end
end
