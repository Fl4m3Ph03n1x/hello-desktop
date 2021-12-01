defmodule Hello.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    Desktop.identify_default_locale(HelloWeb.Gettext)

    children = [
      # Start the Telemetry supervisor
      HelloWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Hello.PubSub},
      # Start the Endpoint (http/https)
      HelloWeb.Endpoint,
      # Start a worker by calling: Hello.Worker.start_link(arg)
      # {Hello.Worker, arg}
      {Desktop.Window,
       [
         app: :hello,
         id: HelloWindow,
         title: "Hello",
         size: {600, 500},
         menubar: Hello.MenuBar,
         icon_menu: Hello.Menu,
         url: &HelloWeb.Endpoint.url/0
       ]}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Hello.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    HelloWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
