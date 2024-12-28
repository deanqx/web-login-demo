defmodule Backend.Session do
  use Ecto.Schema

  schema "sessions" do
    field :session_key, :string
    field :created_at, :utc_datetime
    belongs_to :user, Backend.User, foreign_key: :owner
  end

  def changeset(session, params \\ %{}) do
    session
    |> Ecto.Changeset.cast(params, [:session_key, :owner])
    |> Ecto.Changeset.validate_required([:session_key, :owner])
  end
end
