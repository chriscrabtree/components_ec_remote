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

    <.live_component
      module={Keyboard}
      id="keyboard"
      keyboard_letters={Game.Core.show(@game)[:keyboard]}
    />

    <.show_guess letters={fill_five_chars(@guess.letters)} />

    <div class="flex justify-around">
      <.delete />
      <.enter />
    </div>
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

  @impl true
  def handle_event("back", _params, socket) do
    guess =
      socket.assigns.guess
      |> Guess.back()

    {:noreply, assign(socket, :guess, guess)}
  end

  @impl true
  def handle_event("enter", _params, socket) do
    {:noreply, enter_guess(socket)}
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
    <div class={color_class(@color)}>
      <%= @letter %>
    </div>
    """
  end

  def delete(assigns) do
    ~H"""
    <button
      class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded mt-10"
      phx-click="back"
    >
      Back
    </button>
    """
  end

  def enter(assigns) do
    ~H"""
    <button
      class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded mt-10"
      phx-click="enter"
    >
      Enter
    </button>
    """
  end

  attr :letters, :list
  def show_guess(assigns) do
    ~H"""
    <div class="flex flex-row mt-10 gap-2 w-full justify-center font-bold">
      <%= for letter <- @letters do %>
      <div class="basis-[9%] min-h-[2.2em] min-w-[2.2em] text-center text-black border-solid border-2 border-slate-600 pt-1 pb-1 rounded">
        <%= letter %>
      </div>
      <% end %>
    </div>
    """
  end

  defp reset_game(socket) do
    socket
    |> assign(
      :game,
      Game.new()
    )
  end

  defp reset_guess(socket) do
    socket
    |> assign(:guess, Game.Guess.new())
  end

  defp enter_guess(socket) do
    guess = Guess.show(socket.assigns.guess)

    game =
      socket.assigns.game
      |> Game.Core.guess(guess)

    socket
    |> assign(:game, game)
    |> reset_guess()
  end

  defp color_class(color) do
    case color do
      :gray -> "bg-gray-500 text-white pt-1 pb-1 rounded"
      :yellow -> "bg-yellow-500 text-white pt-1 pb-1 rounded"
      :green -> "bg-green-600 text-white pt-1 pb-1 rounded"
      :white -> "text-black border-solid border-2 border-slate-600 pt-1 pb-1 rounded"
    end
  end

  defp fill_five_chars(letters) when length(letters) < 5 do
    fill_five_chars( [" "] ++  letters)
  end
  defp fill_five_chars(letters), do: Enum.reverse(letters)
end
