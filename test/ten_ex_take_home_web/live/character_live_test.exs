defmodule TenExTakeHomeWeb.CharacterLiveTest do
  use TenExTakeHomeWeb.ConnCase, async: false

  import Mox
  import Phoenix.LiveViewTest
  import TenExTakeHome.MarvelFixtures

  alias TenExTakeHome.Marvel.CharactersCache, as: Cache

  describe "Index" do
    setup [:cache_cleanup, :create_character]

    test "lists all characters", %{conn: conn, character: character} do
      {:ok, _index_live, html} = live(conn, ~p"/characters")

      assert html =~ "Listing Characters"
      assert html =~ character.description
    end
  end

  describe "Show" do
    setup [:cache_cleanup, :create_character]

    test "displays character", %{conn: conn, character: character} do
      {:ok, _show_live, html} = live(conn, ~p"/characters/#{character}")

      assert html =~ "Show Character"
      assert html =~ character.description
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

  defp cache_cleanup(_) do
    Cache.reset()
    :ok
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
end
