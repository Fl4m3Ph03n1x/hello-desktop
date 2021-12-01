defmodule Hello do
  @moduledoc """
  Hello keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """
  use Application
  require Logger

  @app Mix.Project.config()[:app]

  def start(:normal, []) do
    Desktop.identify_default_locale(HelloWeb.Gettext)

    {:ok, sup} = Supervisor.start_link([], name: __MODULE__, strategy: :one_for_one)
    {:ok, _} = Supervisor.start_child(sup, HelloWeb.Sup)

    {:ok, _} =
      Supervisor.start_child(sup, {
        Desktop.Window,
        [
          app: @app,
          id: HelloWindow,
          title: "Hello",
          size: {600, 500},
          icon: "icon.png",
          menubar: Hello.MenuBar,
          icon_menu: Hello.Menu,
          url: &HelloWeb.Endpoint.url/0
        ]
      })
  end

  def config_change(changed, _new, removed) do
    HelloWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
