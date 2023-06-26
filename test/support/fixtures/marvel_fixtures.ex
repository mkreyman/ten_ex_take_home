defmodule TenExTakeHome.MarvelFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `TenExTakeHome.Marvel` context.
  """

  @doc """
  Generate a character.
  """
  def character_fixture(attrs \\ %{}) do
    attrs
    |> Enum.into(%{
      description: "some description",
      name: "some name"
    })
    |> TenExTakeHome.Marvel.Character.create_instance()
  end
end
