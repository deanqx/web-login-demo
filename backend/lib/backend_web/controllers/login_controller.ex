defmodule BackendWeb.LoginController do
  import Ecto.Query

  alias Backend.User
  alias Backend.Repo
  use BackendWeb, :controller

  def create(conn, %{"username" => username, "password" => password}) do
    query =
      from u in User,
        where: u.username == ^username,
        select: u.password_hash

    password_hash = Repo.one(query)

    if Argon2.verify_pass(password, password_hash) do
      json(conn, %{"session_key" => "abc"})
    else
      conn
      |> put_status(:unauthorized)
      |> json(%{"message" => "Nutzername oder Passwort falsch"})
    end
  end
end
