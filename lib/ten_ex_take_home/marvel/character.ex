defmodule TenExTakeHome.Marvel.Character do
  use Ecto.Schema
  import Ecto.Changeset

  @attrs ~w(name description)a

  schema "characters" do
    field :description, :string
    field :name, :string
    field :created_at, :utc_datetime, default: DateTime.utc_now() |> DateTime.truncate(:second)
    field :updated_at, :utc_datetime, default: DateTime.utc_now() |> DateTime.truncate(:second)
  end

  @doc false
  def changeset(character, attrs) do
    character
    |> cast(attrs, @attrs)
    |> validate_required(@attrs)
  end

  @doc false
  def create_instance(%{"id" => id, "name" => name, "description" => description}) do
    %__MODULE__{
      id: id,
      name: name,
      description: description
    }
  end
end
