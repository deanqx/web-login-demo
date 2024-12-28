defmodule BackendWeb.UserController do
  import Ecto.Query

  alias Backend.Repo
  alias Backend.User
  use BackendWeb, :controller

  defp generate_username(generated_username_base, iteration) do
    if iteration > 999 do
      raise "Can't find a free username for " <> generated_username_base
    end

    possible_username =
      if iteration == 0 do
        generated_username_base
      else
        generated_username_base <> Integer.to_string(iteration)
      end

    if Repo.exists?(
         from u in User,
           where: u.username == ^possible_username
       ) do
      generate_username(generated_username_base, iteration + 1)
    else
      possible_username
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
    [first_name | rest_of_name] = String.split(full_name)

    generated_username_base =
      if length(rest_of_name) > 1 do
        String.at(first_name, 0) <> List.last(rest_of_name)
      else
        first_name
      end

    generated_username = generate_username(generated_username_base, 0)

    generated_password = generate_password()
    password_hash = Argon2.hash_pwd_salt(generated_password)

    Repo.insert(%User{username: generated_username, password_hash: password_hash})

    conn
    |> put_status(:created)
    |> json(%{
      "generated_username" => generated_username,
      "generated_password" => generated_password
    })
  end
end
