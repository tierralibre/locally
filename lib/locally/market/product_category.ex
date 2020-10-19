defmodule Locally.Market.ProductCategory do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  @required [:name]
  @params [:id] ++ @required

  embedded_schema do
    field :id, :string
    field :name, :string
  end

  @doc false
  def changeset(product_category, attrs) do
    product_category
    |> cast(attrs, @params)
    |> validate_required(@required)
  end

  def to_schema(data, uuid) do
    %__MODULE__{}
    |> cast(Map.put(data, "id", uuid), @params)
    |> apply_changes()
  end

  def to_schema(%Erm.Core.Entity{type: :product_category} = entity) do
    to_schema(entity.data, entity.uuid)
  end
end
