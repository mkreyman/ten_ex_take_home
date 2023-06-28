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
      "id" => :rand.uniform(1000),
      "name" => Faker.Superhero.name(),
      "description" => Faker.Superhero.descriptor()
    })
    |> TenExTakeHome.Marvel.Character.create_instance()
  end
end
