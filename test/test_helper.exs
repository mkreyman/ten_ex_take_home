ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(TenExTakeHome.Repo, :manual)

Mox.defmock(TenExTakeHome.HTTPClientMock, for: HTTPoison.Base)
