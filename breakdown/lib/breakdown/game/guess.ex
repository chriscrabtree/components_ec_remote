defmodule Breakdown.Game.Guess do
  defstruct letters: []

  def new() do
    %__MODULE__{}
  end

  def move(guess = %__MODULE__{letters: letters}, letter)
      when is_list(letters) and is_binary(letter) do
    letters =
      letters ++ [letter]

    Map.put(guess, :letters, letters)
  end

  def show(_guess = %__MODULE__{letters: letters}) when is_list(letters) do
    Enum.join(letters, "")
  end
end
