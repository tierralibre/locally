defmodule Locally.Repo.Migrations.AddH3Extension do
  use Ecto.Migration

  def up do
    execute "CREATE EXTENSION IF NOT EXISTS postgis"
    execute "CREATE EXTENSION IF NOT EXISTS h3"
  end

  def down do
    execute "DROP EXTENSION IF EXISTS postgis"
    execute "DROP EXTENSION IF EXISTS h3"
  end
end
