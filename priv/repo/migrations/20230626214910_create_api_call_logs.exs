defmodule TenExTakeHome.Repo.Migrations.CreateApiCallLogs do
  use Ecto.Migration

  def change do
    create table(:api_call_logs) do
      add :endpoint, :string
      add :code, :integer
      add :status, :string
      add :timestamp, :utc_datetime

      timestamps()
    end
  end
end
