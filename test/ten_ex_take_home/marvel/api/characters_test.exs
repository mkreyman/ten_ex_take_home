defmodule TenExTakeHome.Marvel.API.CharactersTest do
  use ExUnit.Case, async: false
  import Mox

  alias TenExTakeHome.Marvel.API.Characters

  @http_client TenExTakeHome.HTTPClientMock

  describe "Marvel API module" do
    test "list/0 fetches a list of characters" do
      resp = list_success()

      expect(
        @http_client,
        :get,
        fn _url ->
          {:ok, %HTTPoison.Response{body: resp |> Jason.encode!(), status_code: 200}}
        end
      )

      assert {:ok, resp} == Characters.list()
    end

    test "get/1 fetches a single character by id" do
      resp = get_success(123)

      expect(
        @http_client,
        :get,
        fn _url ->
          {:ok, %HTTPoison.Response{body: resp |> Jason.encode!(), status_code: 200}}
        end
      )

      assert {:ok, resp} == Characters.get(123)
    end

    test "get/1 returns 404 for unknown id" do
      resp = get_not_found()

      expect(
        @http_client,
        :get,
        fn _url ->
          {:ok, %HTTPoison.Response{status_code: 404, body: resp |> Jason.encode!()}}
        end
      )

      assert {:error, resp} == Characters.get(456)
    end
  end

  defp list_success() do
    %{
      "data" => %{
        "results" => [
          %{
            "description" => Faker.Superhero.descriptor(),
            "id" => :rand.uniform(1000),
            "name" => Faker.Superhero.name()
          }
        ]
      }
    }
  end

  defp get_success(id) do
    %{
      "data" => %{
        "results" => [
          %{
            "description" => Faker.Superhero.descriptor(),
            "id" => id,
            "name" => Faker.Superhero.name()
          }
        ]
      }
    }
  end

  defp get_not_found() do
    %{"code" => 404, "status" => "We couldn't find that character"}
  end
end
