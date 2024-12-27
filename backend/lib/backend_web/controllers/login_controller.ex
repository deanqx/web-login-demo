defmodule BackendWeb.LoginController do
  use BackendWeb, :controller

  def create(conn, %{"username" => username, "password" => password}) do
    if password == "123" do
      send_resp(conn, 200, "")
    else
      conn
      |> put_status(:unauthorized)
      |> json(%{"message" => "Nutzername oder Passwort falsch"})
    end
  end
end
