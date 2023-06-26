defmodule TenExTakeHome.MarvelTest do
  use TenExTakeHome.DataCase

  alias TenExTakeHome.Marvel

  describe "characters" do
    alias TenExTakeHome.Marvel.Character

    import TenExTakeHome.MarvelFixtures

    @invalid_attrs %{description: nil, name: nil}

    test "list_characters/0 returns all characters" do
      character = character_fixture()
      assert Marvel.list_characters() == [character]
    end

    test "get_character!/1 returns the character with given id" do
      character = character_fixture()
      assert Marvel.get_character!(character.id) == character
    end

    test "create_character/1 with valid data creates a character" do
      valid_attrs = %{description: "some description", name: "some name"}

      assert {:ok, %Character{} = character} = Marvel.create_character(valid_attrs)
      assert character.description == "some description"
      assert character.name == "some name"
    end

    test "create_character/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Marvel.create_character(@invalid_attrs)
    end

    test "update_character/2 with valid data updates the character" do
      character = character_fixture()
      update_attrs = %{description: "some updated description", name: "some updated name"}

      assert {:ok, %Character{} = character} = Marvel.update_character(character, update_attrs)
      assert character.description == "some updated description"
      assert character.name == "some updated name"
    end

    test "update_character/2 with invalid data returns error changeset" do
      character = character_fixture()
      assert {:error, %Ecto.Changeset{}} = Marvel.update_character(character, @invalid_attrs)
      assert character == Marvel.get_character!(character.id)
    end

    test "delete_character/1 deletes the character" do
      character = character_fixture()
      assert {:ok, %Character{}} = Marvel.delete_character(character)
      assert_raise Ecto.NoResultsError, fn -> Marvel.get_character!(character.id) end
    end

    test "change_character/1 returns a character changeset" do
      character = character_fixture()
      assert %Ecto.Changeset{} = Marvel.change_character(character)
    end
  end
end
