Postgrex.Types.define(
  Locally.PostgresTypes,
  [Geo.PostGIS.Extension] ++ [H3.PostGIS.Extension] ++ Ecto.Adapters.Postgres.extensions(),
  json: Jason
)
