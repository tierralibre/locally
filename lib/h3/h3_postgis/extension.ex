defmodule H3.PostGIS.Extension do
  @behaviour Postgrex.Extension

  def init(opts) do
    Keyword.get(opts, :decode_copy, :copy)
  end

  def matching(_state), do: [type: "h3index"]

  def format(_state), do: :text

  def encode(_state) do
    quote do
      bin when is_binary(bin) ->
        [<<byte_size(bin) :: signed-size(32)>> | bin]
    end
  end

  def decode(:reference) do
    quote do
      <<len::signed-size(32), bin::binary-size(len)>> ->
        bin
    end
  end
  def decode(:copy) do
    quote do
      <<len::signed-size(32), bin::binary-size(len)>> ->
        bin
    end
  end

 def h3_geo_to_h3(lat, long, resolution) do
  query_string = "SELECT h3_geo_to_h3(POINT('#{long}, #{lat}'), #{resolution});"
  Ecto.Adapters.SQL.query!(
    Locally.Repo, query_string
  )
 end

 def list_entities_db() do
  query_string = "SELECT * from entities;"
  Ecto.Adapters.SQL.query!(
    Locally.Repo, query_string
  )
 end

 def entities_db_info() do
  query_string = "SELECT table_name, column_name, data_type FROM information_schema.columns WHERE table_name = 'entities';"
  Ecto.Adapters.SQL.query!(
    Locally.Repo, query_string
  )
 end
end
