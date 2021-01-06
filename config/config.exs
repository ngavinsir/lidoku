# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :lidoku,
  ecto_repos: [Lidoku.Repo]

# Configures the endpoint
config :lidoku, LidokuWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "ZQ5HkuAZjDDVFCkvPXNEUqFQbTdx6NhL8VVTBAPL1N24H1tZ9eqMSjIg6ceoUBJB",
  render_errors: [view: LidokuWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Lidoku.PubSub,
  live_view: [signing_salt: "Scu/V8Km"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
