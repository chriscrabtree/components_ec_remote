defmodule Breakdown.Game.Guess do
  defstruct letters: []

  def new() do
    %__MODULE__{}
  end

  def move(guess = %__MODULE__{letters: letters}, letter)
      when is_list(letters) and is_binary(letter) do
    Map.put(guess, :letters, [letter | letters])
  end

  def show(_guess = %__MODULE__{letters: letters}) when is_list(letters) do
    letters
    |> Enum.reverse()
    |> Enum.join("")
  end

  def back(guess = %__MODULE__{letters: []}) do
    guess
  end

  def back(guess = %__MODULE__{letters: [_letter | letters]}) do
    %{guess | letters: letters}
  end
end
