defmodule BreakdownWeb.Components.Keyboard do
  use BreakdownWeb, :live_component

  # should have an id and a game
  # should have a render function
  # call with live_render...
  # set up state with `def update(assigns, socket)` instead of `def mount(params, session, socket)`
  attr :id, :string

  def render(assigns) do
    ~H"""
    <div id={@id}>
      Keyboard
    </div>
    """
  end
end
