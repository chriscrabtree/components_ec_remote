defmodule BreakdownWeb.GameLive do
  @moduledoc false

  alias Breakdown.Game

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
    <.preview title={@title} game={@game} />
    """
  end

  def reset_game(socket) do
    socket
    |> assign(:game, Game.Core.new())
  end

  def preview(assigns) do
    ~H"""
    <h2>
      <%= @title %>
    </h2>
    <pre>
       <%= inspect(@game) %>
    </pre>
    """
  end
end
