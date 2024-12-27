defmodule BackendWeb.UserController do
  alias Backend.Repo
  alias Backend.User
  use BackendWeb, :controller

  # Format: 1234-0003-1234
  defp generate_password() do
    part1 = :crypto.strong_rand_bytes(2) |> :binary.decode_unsigned() |> rem(10000)
    part2 = :crypto.strong_rand_bytes(2) |> :binary.decode_unsigned() |> rem(10000)
    part3 = :crypto.strong_rand_bytes(2) |> :binary.decode_unsigned() |> rem(10000)

    String.pad_leading(Integer.to_string(part1), 4, "0") <>
      "-" <>
      String.pad_leading(Integer.to_string(part2), 4, "0") <>
      "-" <>
      String.pad_leading(Integer.to_string(part3), 4, "0")
  end

  def create(conn, %{"username" => username}) do
    password_temporary = generate_password()
    password_hash = Argon2.hash_pwd_salt(password_temporary)

    Repo.insert(%User{username: username, password_hash: password_hash})
    # TODO handle already existing

    conn
    |> put_status(:created)
    |> json(%{"password_temporary" => password_temporary})
  end
end
