defmodule BackendWeb.LoginController do
  import Ecto.Query

  alias Backend.User
  alias Backend.Session
  alias Backend.Repo
  use BackendWeb, :controller

  def create(conn, %{"username" => username, "password" => password}) do
    case Repo.one(
           from u in User,
             where: u.username == ^username,
             select: [u.id, u.password_hash]
         ) do
      nil ->
        conn
        |> put_status(:unauthorized)
        |> json(%{"message" => "Nutzername oder Passwort falsch"})

      [uid, password_hash] ->
        if Argon2.verify_pass(password, password_hash) do
          session_key = :crypto.strong_rand_bytes(32) |> Base.encode64()

          Repo.insert(%Session{session_key: session_key, owner: uid})

          json(conn, %{"session_key" => session_key})
        else
          conn
          |> put_status(:unauthorized)
          |> json(%{"message" => "Nutzername oder Passwort falsch"})
        end
    end
  end
end
