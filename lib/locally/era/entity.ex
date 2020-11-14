defmodule Locally.Era.Entity do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "entities" do
    field :content, :map
    field :h3index, H3.PostGIS.H3Index
    field :name, :string
    field :status, :string
    field :topics, {:array, :string}
    field :type, :string
    field :creator_id, :binary_id

    timestamps()
  end

  @doc false
  def changeset(entity, attrs) do
    entity
    |> cast(attrs, [:h3index, :name, :type, :status, :topics, :content])
    |> validate_required([:name, :type])
  end
end
