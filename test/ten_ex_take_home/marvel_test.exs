defmodule TenExTakeHome.MarvelTest do
  use TenExTakeHome.DataCase, async: false

  import Mox
  import TenExTakeHome.MarvelFixtures

  alias TenExTakeHome.Marvel
  alias TenExTakeHome.Marvel.CharactersCache, as: Cache

  describe "characters" do
    setup [:cache_cleanup, :create_character]

    test "list_characters/0 returns all characters", %{character: character} do
      assert Marvel.list_characters() == [character]
    end

    test "get_character!/1 returns the character with given id", %{character: character} do
      assert Marvel.get_character!(character.id) == character
    end
  end

  defp create_character(_) do
    http_client = TenExTakeHome.HTTPClientMock
    character = character_fixture()

    resp =
      character
      |> success()
      |> Jason.encode!()

    expect(
      http_client,
      :get,
      2,
      fn _url ->
        {:ok, %HTTPoison.Response{body: resp, status_code: 200}}
      end
    )

    %{character: character}
  end

  defp success(character) do
    %{
      "data" => %{
        "results" => [
          %{
            "id" => character.id,
            "name" => character.name,
            "description" => character.description
          }
        ]
      }
    }
  end

  defp cache_cleanup(_) do
    Cache.reset()
    :ok
  end
end
