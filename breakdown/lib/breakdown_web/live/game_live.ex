defmodule BreakdownWeb.GameLive do
  @moduledoc false

  alias Breakdown.Game
  alias Breakdown.Game.Guess
  alias BreakdownWeb.Components.Keyboard

  use BreakdownWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> reset_game()
     |> reset_guess()
     |> assign(:title, "Welcome to Word X")}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <.grid>
      <.word :for={letters <- @game.scores |> Enum.reverse()} letters={letters} />
    </.grid>

    <.live_component module={Keyboard} id="keyboard" keyboard_letters={@game.keyboard} />

    <.preview game={@game} guess={@guess} />
    """
  end

  @impl true
  def handle_event("guess", %{"letter" => letter}, socket) do
    guess =
      socket.assigns.guess
      |> Guess.move(letter)

    {:noreply, assign(socket, :guess, guess)}
  end

  def reset_game(socket) do
    socket
    |> assign(
      :game,
      Game.Core.new("guess")
      |> Game.Core.guess("dress")
      |> Game.Core.guess("spend")
      |> Game.Core.guess("sting")
      # |> Game.Core.guess("GUESS")
      |> Game.Core.show()
    )
  end

  def reset_guess(socket) do
    socket
    |> assign(:guess, Game.Guess.new())
  end

  attr :title, :string, default: "Welcome"
  attr :game, :any, required: true
  attr :guess, :any, required: true

  def preview(assigns) do
    ~H"""
    <h2>
      <%= @title %>
    </h2>
    <pre>
      <%= inspect(@guess, pretty: true) %>
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
    <div class={color_class(@color)}>
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
