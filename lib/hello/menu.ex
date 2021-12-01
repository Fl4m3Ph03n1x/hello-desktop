defmodule Hello.Menu do
  @moduledoc """
    Menu that is shown when a user click on the taskbar icon of the Hello
  """
  import HelloWeb.Gettext
  use Desktop.Menu

  def handle_event(command) do
    case command do
      <<"quit">> -> Desktop.Window.quit()
    end

    {:noreply, []}
  end

  def mount(menu) do
    menu = assign(menu, todos: [])
    set_state_icon(menu)
    {:ok, menu}
  end

  def handle_info(:changed, menu) do
    menu = assign(menu, todos: [])

    set_state_icon(menu)

    {:noreply, menu}
  end

  defp set_state_icon(menu) do
    if checked?(menu.todos) do
      Menu.set_icon(menu, {:file, "icon32x32-done.png"})
    else
      Menu.set_icon(menu, {:file, "icon32x32.png"})
    end
  end

  defp checked?([]) do
    true
  end

  defp checked?([%{status: "done"} | todos]) do
    checked?(todos)
  end

  defp checked?([%{status: _} | todos]) do
    false && checked?(todos)
  end
end
