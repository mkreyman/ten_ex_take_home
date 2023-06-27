defmodule TenExTakeHome.Marvel.CharactersCache do
  use TenExTakeHome.Cache.ETSTableHelper,
    schema: TenExTakeHome.Marvel.Character,
    repo: TenExTakeHome.Repo

  alias TenExTakeHome.Marvel.API.Characters, as: API
  alias TenExTakeHome.Marvel.Character
  alias TenExTakeHome.Analytics.ApiCalls

  @endpoint "/v1/public/characters"

  def lookup(character_id) do
    case get(character_id) do
      {:ok, _cached_character} = cached_result ->
        cached_result

      _ ->
        with {:ok, response} <- API.get(character_id) do
          log_api_call(%{endpoint: @endpoint, code: response["code"], status: response["status"]})

          attrs =
            response["data"]["results"]
            |> List.first()

          character = Character.create_instance(attrs)
          put(character_id, {:ok, character})

          {:ok, character}
        else
          error_message -> {:error, error_message}
        end
    end
  end

  def lookup_all(params) do
    case get_all() do
      {:ok, cache} ->
        {:ok, parse_cache_results(cache)}

      _ ->
        with {:ok, response} <- API.list(params) do
          log_api_call(%{endpoint: @endpoint, code: response["code"], status: response["status"]})

          results = response["data"]["results"]
          characters = Enum.map(results, &Character.create_instance/1)
          cache_characters(characters)

          {:ok, characters}
        else
          error_message -> {:error, error_message}
        end
    end
  end

  defp cache_characters(characters) do
    Enum.each(characters, fn character ->
      put(character.id, {:ok, character})
    end)
  end

  defp parse_cache_results(cache_results) do
    Enum.map(cache_results, fn {_, {:ok, %TenExTakeHome.Marvel.Character{} = character}, _} ->
      character
    end)
  end

  defp log_api_call(attrs) do
    Task.start(fn -> ApiCalls.log_api_call(attrs) end)
  end
end
