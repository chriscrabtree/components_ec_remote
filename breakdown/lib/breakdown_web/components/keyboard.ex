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
    <div class="font-bold">
      <div class="flex flex-row mt-2 gap-1 w-full justify-center">
        <.letter :for={{letter, color}  <- keyboard_qwert_row1(@keyboard_letters)} letter={letter} color={color} />
      </div>
      <div class="flex flex-row mt-2 gap-1 w-full justify-center">
        <.letter :for={{letter, color}  <- keyboard_qwert_row2(@keyboard_letters)} letter={letter} color={color} />
      </div>
      <div class="flex flex-row mt-2 gap-1 w-full justify-center">
        <.letter :for={{letter, color}  <- keyboard_qwert_row3(@keyboard_letters)} letter={letter} color={color} />
      </div>
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
      :gray   -> "basis-[9%] min-h-[2.2em] min-w-[2.2em] text-center bg-gray-500 text-white pt-1 pb-1 rounded"
      :yellow -> "basis-[9%] min-h-[2.2em] min-w-[2.2em] text-center bg-yellow-500 text-white pt-1 pb-1 rounded"
      :green  -> "basis-[9%] min-h-[2.2em] min-w-[2.2em] text-center bg-green-600 text-white pt-1 pb-1 rounded"
      :white  -> "basis-[9%] min-h-[2.2em] min-w-[2.2em] text-center text-black border-solid border-2 border-slate-600 pt-1 pb-1 rounded"
    end
  end

  defp keyboard_qwert_row1(letters) do
    ["q","w","e","r","t","y","u","i","o","p"]
    |> keyboard_quert_reduce(letters)
  end

  defp keyboard_qwert_row2(letters) do
    ["a","s","d","f","g","h","j","k","l"]
    |> keyboard_quert_reduce(letters)
  end

  defp keyboard_qwert_row3(letters) do
    ["z","x","c","v","b","n","m"]
    |> keyboard_quert_reduce(letters)
  end

  defp keyboard_quert_reduce(order, letters) do
    Enum.reduce(order, [], fn letter,acc ->
      [ {letter , Map.get(letters, letter) } ] ++ acc
      end) |> Enum.reverse()
  end
end
