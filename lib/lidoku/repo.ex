defmodule Lidoku.Repo do
  use Ecto.Repo,
    otp_app: :lidoku,
    adapter: Ecto.Adapters.Postgres
end
