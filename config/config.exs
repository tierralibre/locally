# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :locally,
  ecto_repos: [Locally.Repo],
  generators: [binary_id: true]

config :erm,
  ecto_repos: [Erm.Repo],
  generators: [binary_id: true]

# Configures the endpoint
config :locally, LocallyWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "15JFl6tAtJ2uoRFd4qxl24UhhYsqfcnPzO1mAYKIAIs3Mg1L4/utnlM9Mkl1Pnbk",
  render_errors: [view: LocallyWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Locally.PubSub,
  live_view: [signing_salt: "R/RCcpgN"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
