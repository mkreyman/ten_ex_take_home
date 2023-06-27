defmodule TenExTakeHome.Analytics.ApiCalls do
  import Ecto.Query, warn: false

  alias TenExTakeHome.Analytics.ApiCallLog
  alias TenExTakeHome.Repo

  def list_api_calls() do
    query = from(l in ApiCallLog, select: l)
    Repo.all(query)
  end

  def log_api_call(%{endpoint: _endpoint, code: _code, status: _status} = attrs) do
    %ApiCallLog{}
    |> ApiCallLog.changeset(attrs)
    |> Repo.insert()
  end
end
