defmodule Locally.Market.Stock do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  @required [:existence, :price, :units]
  @params @required ++ [:id, :from, :to]

  embedded_schema do
    field :id, :string
    field :from, :string
    field :to, :string
    field :existence, :boolean, default: false
    field :price, :integer
    field :units, :integer
    field :product_name, :string, virtual: true
    field :store_name, :string, virtual: true
  end

  @doc false
  def changeset(store, attrs) do
    store
    |> cast(attrs, @params)
    |> validate_required(@required)
  end

  def to_schema(data, from_uuid, to_uuid) do
    %__MODULE__{}
    |> cast(
      data
      |> Map.put("from", from_uuid)
      |> Map.put("to", to_uuid)
      |> Map.put("id", from_uuid <> "," <> to_uuid),
      @params
    )
    |> apply_changes()
  end

  def to_schema(%Erm.Core.Relation{type: "stock"} = relation) do
    to_schema(relation.data, relation.from, relation.to)
  end
end
