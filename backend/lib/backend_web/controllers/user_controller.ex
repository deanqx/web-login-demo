defmodule BackendWeb.UserController do
  import Ecto.Query

  alias Backend.Repo
  alias Backend.User
  use BackendWeb, :controller

  # Format: Dean Schneider -> dschneider2
  defp generate_username(uid, full_name) do
    [first_name | rest_of_name] = String.split(full_name)

    generated_username_base =
      if length(rest_of_name) > 0 do
        String.downcase(String.at(first_name, 0)) <> String.downcase(List.last(rest_of_name))
      else
        String.downcase(first_name)
      end

    if Repo.exists?(
         from u in User,
           select: u.username,
           where: u.username == ^generated_username_base
       ) do
      IO.puts("here")
      generated_username_base <> Integer.to_string(uid)
    else
      IO.puts(generated_username_base)
      generated_username_base
    end
  end

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

  def create(conn, %{"full_name" => full_name}) do
    generated_password = generate_password()
    password_hash = Argon2.hash_pwd_salt(generated_password)

    {:ok, created_user} = Repo.insert(%User{password_hash: password_hash})

    generated_username = generate_username(created_user.id, full_name)

    Repo.update(Ecto.Changeset.change(created_user, %{username: generated_username}))

    conn
    |> put_status(:created)
    |> json(%{
      "generated_username" => generated_username,
      "generated_password" => generated_password
    })
  end
end
