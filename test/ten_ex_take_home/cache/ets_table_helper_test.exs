defmodule TenExTakeHome.Cache.ETSTableHelperTest do
  use ExUnit.Case, async: false
  alias TenExTakeHome.Marvel.CharactersCache, as: Cache

  @table_name Cache

  describe "ETS cache helper" do
    setup :cache_cleanup

    test "get/1 returns :no_key when key is nil" do
      assert {:error, :no_key} == Cache.get(nil)
    end

    test "get/1 returns the error tuple when an error is passed as the key" do
      error = {:error, :not_found}
      assert error == Cache.get(error)
    end

    test "get/1 returns the value when it exists in the table" do
      :ets.insert(@table_name, {:key, :value, 0})
      assert {:ok, :value, 0} == Cache.get(:key)
    end

    test "get/1 returns :notfound when the key does not exist in the table" do
      assert :notfound == Cache.get(:nonexistent)
    end

    test "put/2 inserts the key-value pair into the table" do
      assert :value == Cache.put(:key, :value)
      assert {:ok, :value, _} = Cache.get(:key)
    end

    test "get_all/0 returns a list of all values in the table" do
      :ets.insert(@table_name, {:key1, :value1, 0})
      :ets.insert(@table_name, {:key2, :value2, 0})

      expected = [
        {:key2, :value2, 0},
        {:key1, :value1, 0}
      ]

      assert {:ok, expected} == Cache.get_all()
    end

    test "get_all/0 returns :notfound when the table is empty" do
      assert :notfound == Cache.get_all()
    end

    test "reset/0 deletes all objects in the table" do
      :ets.insert(@table_name, {:key, :value, 0})
      assert :reset == Cache.reset()
      assert [] == :ets.tab2list(@table_name)
    end

    test "cleanup/1 deletes expired entries from the table" do
      old = System.system_time(:second) - 60
      newer = System.system_time(:second) - 10
      :ets.insert(@table_name, {:key1, :value1, old})
      :ets.insert(@table_name, {:key2, :value2, newer})
      assert {:cleanup, 1} = Cache.cleanup(30)
      assert [{:key2, :value2, newer}] == :ets.tab2list(@table_name)
    end
  end

  defp cache_cleanup(_) do
    Cache.reset()
    :ok
  end
end
