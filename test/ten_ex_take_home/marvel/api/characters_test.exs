defmodule TenExTakeHome.Marvel.API.CharactersTest do
  use ExUnit.Case, async: true
  import Mox

  alias TenExTakeHome.Marvel.API.Characters

  @http_client TenExTakeHome.HTTPClientMock

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

  defp list_success() do
    %{
      "attributionHTML" => "string",
      "attributionText" => "string",
      "code" => "int",
      "copyright" => "string",
      "data" => %{
        "count" => "int",
        "limit" => "int",
        "offset" => "int",
        "results" => [
          %{
            "comics" => %{
              "available" => "int",
              "collectionURI" => "string",
              "items" => [%{"name" => "string", "resourceURI" => "string"}],
              "returned" => "int"
            },
            "description" => "string",
            "events" => %{
              "available" => "int",
              "collectionURI" => "string",
              "items" => [%{"name" => "string", "resourceURI" => "string"}],
              "returned" => "int"
            },
            "id" => "int",
            "modified" => "Date",
            "name" => "string",
            "resourceURI" => "string",
            "series" => %{
              "available" => "int",
              "collectionURI" => "string",
              "items" => [%{"name" => "string", "resourceURI" => "string"}],
              "returned" => "int"
            },
            "stories" => %{
              "available" => "int",
              "collectionURI" => "string",
              "items" => [
                %{"name" => "string", "resourceURI" => "string", "type" => "string"}
              ],
              "returned" => "int"
            },
            "thumbnail" => %{"extension" => "string", "path" => "string"},
            "urls" => [%{"type" => "string", "url" => "string"}]
          }
        ],
        "total" => "int"
      },
      "etag" => "string",
      "status" => "string"
    }
  end

  defp get_success(id) do
    %{
      "attributionHTML" => "string",
      "attributionText" => "string",
      "code" => "int",
      "copyright" => "string",
      "data" => %{
        "count" => "int",
        "limit" => "int",
        "offset" => "int",
        "results" => [
          %{
            "comics" => %{
              "available" => "int",
              "collectionURI" => "string",
              "items" => [%{"name" => "string", "resourceURI" => "string"}],
              "returned" => "int"
            },
            "description" => "string",
            "events" => %{
              "available" => "int",
              "collectionURI" => "string",
              "items" => [%{"name" => "string", "resourceURI" => "string"}],
              "returned" => "int"
            },
            "id" => id,
            "modified" => "Date",
            "name" => "string",
            "resourceURI" => "string",
            "series" => %{
              "available" => "int",
              "collectionURI" => "string",
              "items" => [%{"name" => "string", "resourceURI" => "string"}],
              "returned" => "int"
            },
            "stories" => %{
              "available" => "int",
              "collectionURI" => "string",
              "items" => [
                %{"name" => "string", "resourceURI" => "string", "type" => "string"}
              ],
              "returned" => "int"
            },
            "thumbnail" => %{"extension" => "string", "path" => "string"},
            "urls" => [%{"type" => "string", "url" => "string"}]
          }
        ],
        "total" => "int"
      },
      "etag" => "string",
      "status" => "string"
    }
  end

  defp get_not_found() do
    %{"code" => 404, "status" => "We couldn't find that character"}
  end
end
