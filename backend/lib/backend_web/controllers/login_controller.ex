defmodule BackendWeb.LoginController do
  use BackendWeb, :controller

  def create(conn, %{"username" => username, "password" => password}) do
    response = %{"message" => "Received", "key" => username}
    json(conn, response)
  end
end
