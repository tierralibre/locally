defmodule Locally.Market.Product do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  @required [
    :bar_code,
    :brand,
    :model,
    :name
  ]
  @params [:id, :depht, :description, :details, :discontinued, :height, :weight, :width] ++
            @required

  embedded_schema do
    field :id, :string
    field :bar_code, :string
    field :brand, :string
    field :depht, :integer
    field :description, :string
    field :details, :string
    field :discontinued, :boolean, default: false
    field :height, :integer
    field :model, :string
    field :name, :string
    field :weight, :integer
    field :width, :integer
    field :categories, :string, virtual: true, default: "[]"
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

  def to_schema(%Erm.Core.Entity{type: :product} = entity) do
    to_schema(entity.data, entity.uuid)
  end
end
