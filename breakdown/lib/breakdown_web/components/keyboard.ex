defmodule BreakdownWeb.Components.Keyboard do
  use BreakdownWeb, :live_component

  # should have an id and a game
  # should have a render function
  # call with live_render...
  # set up state with `def update(assigns, socket)` instead of `def mount(params, session, socket)`

  def update(assigns, socket) do
    {:ok, assign(socket, assigns)}
  end

  attr :id, :string
  attr :color, :string, required: true
  attr :keyboard_letters, :list

  def render(assigns) do
    ~H"""
    <div class="grid grid-cols-10 gap-3 text-center font-bold" id={@id}>
      <.letter :for={{letter, color} <- @keyboard_letters} letter={letter} color={color} />
    </div>
    """
  end

  attr :letter, :string, required: true
  attr :color, :atom, required: true

  def letter(assigns) do
    ~H"""
    <div phx-click="guess" phx-value-letter={@letter} class={color_class(@color)}>
      <%= @letter %>
    </div>
    """
  end

  defp color_class(color) do
    case color do
      :gray -> "bg-gray-500 text-white pt-1 pb-1 rounded"
      :yellow -> "bg-yellow-500 text-white pt-1 pb-1 rounded"
      :green -> "bg-green-600 text-white pt-1 pb-1 rounded"
      :white -> "text-black border-solid border-2 border-slate-600 pt-1 pb-1 rounded"
    end
  end
end
