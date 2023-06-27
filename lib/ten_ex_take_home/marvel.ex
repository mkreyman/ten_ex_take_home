defmodule TenExTakeHome.Marvel do
  @moduledoc """
  The Marvel context.
  """

  import Ecto.Query, warn: false

  alias TenExTakeHome.Marvel.CharactersCache

  @doc """
  Returns the list of characters.

  ## Examples

      iex> list_characters()
      [%Character{}, ...]

  """
  def list_characters do
    params = %{offset: 0, limit: 100}

    with {:ok, characters} <- CharactersCache.lookup_all(params) do
      characters
    else
      _ ->
        []
    end
  end

  @doc """
  Gets a single character.

  Raises `Ecto.NoResultsError` if the Character does not exist.

  ## Examples

      iex> get_character!(123)
      %Character{}

      iex> get_character!(456)
      ** (Ecto.NoResultsError)

  """
  def get_character!(id) do
    with {:ok, character} <- CharactersCache.lookup(id) do
      character
    else
      {:error, _} ->
        nil
    end
  end
end
