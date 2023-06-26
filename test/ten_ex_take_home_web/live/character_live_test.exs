defmodule TenExTakeHomeWeb.CharacterLiveTest do
  use TenExTakeHomeWeb.ConnCase

  import Phoenix.LiveViewTest
  import TenExTakeHome.MarvelFixtures

  @create_attrs %{description: "some description", name: "some name"}
  @update_attrs %{description: "some updated description", name: "some updated name"}
  @invalid_attrs %{description: nil, name: nil}

  defp create_character(_) do
    character = character_fixture()
    %{character: character}
  end

  describe "Index" do
    setup [:create_character]

    test "lists all characters", %{conn: conn, character: character} do
      {:ok, _index_live, html} = live(conn, ~p"/characters")

      assert html =~ "Listing Characters"
      assert html =~ character.description
    end
  end

  describe "Show" do
    setup [:create_character]

    test "displays character", %{conn: conn, character: character} do
      {:ok, _show_live, html} = live(conn, ~p"/characters/#{character}")

      assert html =~ "Show Character"
      assert html =~ character.description
    end
  end
end
