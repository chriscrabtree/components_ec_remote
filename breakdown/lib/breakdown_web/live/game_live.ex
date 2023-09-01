defmodule BreakdownWeb.GameLive do
  use BreakdownWeb, :live_view
  alias Breakdown.Game

  def mount(_params, _session, socket) do
    {:ok,
      socket
      |> reset_game()
      |> assign(:title, "Welcome to Word X")
    }
  end

  def reset_game(socket) do
    assign(socket, :game, Game.new())
  end
  def render(assigns) do
    ~H"""
    <.preview title={@title} game={@game} />
    """
  end

  def preview(assigns) do
    ~H"""
       <h2><%= @title %></h2>
       <pre><%= inspect(@game) %></pre>
       <pre><%= inspect(assigns, pretty: true) %></pre>
    """
  end

end
