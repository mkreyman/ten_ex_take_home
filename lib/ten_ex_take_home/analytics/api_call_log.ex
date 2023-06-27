defmodule TenExTakeHome.Analytics.ApiCallLog do
  use Ecto.Schema
  import Ecto.Changeset

  @attrs ~w(
    endpoint
    code
    status
    timestamp)a

  schema "api_call_logs" do
    field :endpoint, :string
    field :code, :integer
    field :status, :string
    field :timestamp, :utc_datetime, default: DateTime.utc_now() |> DateTime.truncate(:second)

    timestamps()
  end

  @doc false
  def changeset(log, attrs) do
    log
    |> cast(attrs, @attrs)
    |> validate_required(@attrs)
  end
end
