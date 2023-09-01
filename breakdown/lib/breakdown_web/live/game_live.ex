defmodule BreakdownWeb.GameLive do
  @moduledoc false

  alias Breakdown.Game
  alias BreakdownWeb.Components.Keyboard

  use BreakdownWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> reset_game()
     |> assign(:title, "Welcome to Word X")}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <.grid>
      <.word :for={letters <- @game.scores |> Enum.reverse()} letters={letters} />
    </.grid>

    <.live_component module={Keyboard} id="keyboard" />

    <.preview game={@game} />
    """
  end

  def reset_game(socket) do
    socket
    |> assign(
      :game,
      Game.Core.new("GUESS") |> Game.Core.guess("DRESS") |> Game.Core.guess("GUESS")
    )
  end

  attr :title, :string, default: "Welcome"
  attr :game, Game.Core, required: true

  def preview(assigns) do
    ~H"""
    <h2>
      <%= @title %>
    </h2>
    <pre>
       <%= inspect(@game, pretty: true) %>
    </pre>
    """
  end

  attr :letters, :list, required: true

  def word(assigns) do
    ~H"""
    <.letter :for={{letter, color} <- @letters} letter={letter} color={color} />
    """
  end

  slot :inner_block, required: true

  def grid(assigns) do
    ~H"""
    <div class="grid grid-cols-5 gap-4 text-center font-bold mb-10">
      <%= render_slot(@inner_block) %>
    </div>
    """
  end

  attr :letter, :string, required: true
  attr :color, :atom, required: true

  def letter(assigns) do
    ~H"""
    <div class={["text-white pt-2 pb-2 rounded", color_class(@color)]}>
      <%= @letter %>
    </div>
    """
  end

  defp color_class(color) do
    case color do
      :gray -> "bg-gray-500"
      :yellow -> "bg-yellow-500"
      :green -> "bg-green-600"
    end
  end
end
