import Config

config :hello, HelloWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4000],
  cache_static_manifest: "priv/static/cache_manifest.json"

# Do not print debug messages in production
config :logger, level: :info
