defmodule TenExTakeHome.Cache.ETSTableHelper do
  @moduledoc """

    Options:
      ttl (optional): TTL for cache entries, in seconds. Default: 3600 sec

  """

  require Logger

  defmodule Config do
    @doc false
    defstruct ttl: 3600,
              persist: false,
              schema: nil,
              repo: nil
  end

  defmacro __using__(opts \\ []) do
    {opts, []} = opts |> Macro.to_string() |> Code.eval_string()

    quote do
      use GenServer

      alias TenExTakeHome.Cache.ETSTableHelper

      @table_name __MODULE__

      def start_link(opts \\ []) do
        {:ok, _pid} = GenServer.start_link(__MODULE__, opts, name: __MODULE__)
      end

      def get(nil) do
        {:error, :no_key}
      end

      def get({:error, _reason} = error) do
        error
      end

      def get(key) do
        GenServer.call(__MODULE__, {:get, key})
      end

      def put(key, value) do
        GenServer.call(__MODULE__, {:put, key, value, :now})
      end

      def put(key, value, timestamp) when is_integer(timestamp) do
        GenServer.call(__MODULE__, {:put, key, value, timestamp})
      end

      def get_all() do
        GenServer.call(__MODULE__, {:get_all, nil})
      end

      def reset() do
        GenServer.call(__MODULE__, {:reset, nil})
      end

      def cleanup(ttl) when is_integer(ttl) and ttl > 0 do
        GenServer.call(__MODULE__, {:cleanup, ttl})
      end

      def persist() do
        GenServer.call(__MODULE__, :persist)
      end

      # callbacks

      def init(opts) do
        ETSTableHelper.init(@table_name, unquote(opts))
      end

      def handle_call(msg, from, state) do
        ETSTableHelper.handle_call(@table_name, msg, from, state)
      end

      def handle_info(msg, state) do
        ETSTableHelper.handle_info(@table_name, msg, state)
      end
    end
  end

  def init(table_name, opts) do
    ttl = Keyword.get(opts, :ttl, 3600)
    persist? = Keyword.get(opts, :persist, false)
    schema = Keyword.get(opts, :schema, nil)
    repo = Keyword.get(opts, :repo, nil)
    cache_type = Keyword.get(opts, :cache_type, :set)

    :ets.new(table_name, [:named_table, :public, cache_type, read_concurrency: true])

    config = %Config{
      ttl: ttl,
      persist: persist?,
      schema: schema,
      repo: repo
    }

    Process.send_after(self(), {:cleanup, ttl}, ttl * 1000)

    {:ok, config}
  end

  def handle_call(table_name, {:get, key}, _from, state) do
    case :ets.lookup(table_name, key) do
      [{^key, value, timestamp}] ->
        {:reply, {:ok, value, timestamp}, state}

      [] ->
        {:reply, :notfound, state}
    end
  end

  def handle_call(table_name, {:put, key, value, timestamp}, _from, state) do
    timestamp =
      case timestamp do
        :now -> System.system_time(:second)
        ts when is_integer(ts) -> ts
      end

    :ets.insert(table_name, {key, value, timestamp})

    {:reply, value, state}
  end

  def handle_call(table_name, {:get_all, _}, _from, state) do
    case :ets.tab2list(table_name) do
      [_ | _] = values ->
        {:reply, {:ok, values}, state}

      [] ->
        {:reply, :notfound, state}
    end
  end

  def handle_call(table_name, {:reset, _}, _from, state) do
    :ets.delete_all_objects(table_name)

    {:reply, :reset, state}
  end

  def handle_call(table_name, {:cleanup, ttl}, _from, state) do
    persist(table_name, state)
    num_of_entries = select_delete(table_name, ttl)

    {:reply, {:cleanup, num_of_entries}, state}
  end

  def handle_call(table_name, :persist, _from, state) do
    entries = persist(table_name, state)

    {:reply, {:persist, entries}, state}
  end

  def handle_info(table_name, {:cleanup, ttl}, state) do
    table_name
    |> persist(state)

    select_delete(table_name, ttl)

    Process.send_after(self(), {:cleanup, ttl}, ttl * 1000)

    {:noreply, state}
  end

  def handle_info(table_name, :persist, state) do
    persist(table_name, state)

    {:noreply, state}
  end

  defp select_delete(table_name, ttl) do
    outdated = System.system_time(:second) - ttl

    :ets.select_delete(table_name, [
      {{:"$1", :"$2", :"$3"}, [{:<, :"$3", {:const, outdated}}], [true]}
    ])
  end

  defp persist(_table_name, %{persist: false} = _opts), do: :noop

  defp persist(table_name, %{ttl: ttl, schema: schema, repo: repo} = _opts)
       when is_integer(ttl) and ttl > 0 and is_atom(schema) and is_atom(repo) do
    to_be_persisted = get_expired(table_name, ttl)

    case to_be_persisted do
      [_ | _] ->
        num_of_fields =
          :fields
          |> schema.__schema__()
          |> length()

        to_be_persisted
        |> Enum.map(fn attrs ->
          attrs
          |> schema.new_event_changeset()
          |> Map.get(:changes)
          |> Map.put(:inserted_at, DateTime.utc_now())
          |> Map.put(:updated_at, DateTime.utc_now())
        end)
        # Postgresql protocol has a limit of maximum parameters (65535)
        |> Enum.chunk_every(Integer.floor_div(65535, num_of_fields))
        |> Enum.each(fn rows ->
          Ecto.Multi.new()
          |> Ecto.Multi.insert_all(:insert_all, schema, rows)
          |> repo.transaction()
        end)

        to_be_persisted

      _ ->
        []
    end
  end

  defp get_expired(table_name, ttl) do
    ripe = System.system_time(:second) - ttl

    :ets.select(table_name, [
      {{:"$1", :"$2", :"$3"}, [{:<, :"$3", {:const, ripe}}], [:"$2"]}
    ])
    |> MapSet.new()
    |> MapSet.to_list()
  end
end
