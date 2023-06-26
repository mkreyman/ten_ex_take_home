defmodule TenExTakeHome.Cache.CacheSupervisor do
  @moduledoc false

  use Supervisor

  alias TenExTakeHome.Marvel.CharactersCache

  def start_link(opts) do
    Supervisor.start_link(__MODULE__, opts, name: __MODULE__)
  end

  @impl true
  def init(_opts) do
    children = [
      {CharactersCache, []}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
