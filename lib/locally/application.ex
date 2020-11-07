defmodule Locally.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  alias Erm.Boundary.ApplicationManager


  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Locally.Repo,
      # Start the Telemetry supervisor
      LocallyWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Locally.PubSub},
      {ApplicationManager, ApplicationManager.registered_applications()},
      # Start the Endpoint (http/https)
      LocallyWeb.Endpoint
      # Start a worker by calling: Locally.Worker.start_link(arg)
      # {Locally.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Locally.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    LocallyWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
