defmodule Backend.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :username, :string
    field :password_hash, :string

    timestamps(type: :utc_datetime)
  end

  def changeset(user, params \\ %{}) do
    user
    |> cast(params, [:username, :password_hash])
    |> validate_required([:password_hash])
  end
end
