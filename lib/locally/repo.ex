defmodule Locally.Repo do
  use Ecto.Repo,
    otp_app: :locally,
    adapter: Ecto.Adapters.Postgres
end
