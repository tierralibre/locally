defmodule Locally.Market.Store do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  @required [:name, :postal_code, :postal_direction, :owner_id]
  @params [:id] ++ @required

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
    |> cast(attrs, @params)
    |> validate_required(@required)
  end

  def to_schema(data, uuid) do
    %__MODULE__{}
    |> cast(Map.put(data, "id", uuid), @params)
    |> apply_changes()
  end

  def to_schema(%Erm.Core.Entity{type: "store"} = entity) do
    to_schema(entity.data, entity.id)
  end
end
