defmodule BackendWeb.UserController do
  import Ecto.Query

  alias Backend.Repo
  alias Backend.User
  use BackendWeb, :controller

  # Format: Dean Schneider -> dschneider2
  defp generate_username(full_name) do
    [first_name | rest_of_name] = String.split(full_name)

    generated_username_base =
      if length(rest_of_name) > 0 do
        String.downcase(String.at(first_name, 0)) <> String.downcase(List.last(rest_of_name))
      else
        String.downcase(first_name)
      end

    last_occurrence =
      Repo.one(
        from u in User,
          select: u.username,
          where: like(u.username, ^(generated_username_base <> "%")),
          order_by: [desc: u.username],
          limit: 1
      )

    if last_occurrence do
      IO.puts(last_occurrence)

      suffix =
        last_occurrence
        |> String.slice(String.length(generated_username_base)..-1//1)

      suffix_incremented =
        if suffix == "" do
          1
        else
          String.to_integer(suffix, 10) + 1
        end

      IO.puts(suffix)

      generated_username_base <> Integer.to_string(suffix_incremented)
    else
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
    generated_username = generate_username(full_name)
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
