use Mix.Config

config :elixirreport,
  db_host: "localhost",
  db_port: 27017,
  db_db: "reports",
  db_tables: [
    "reports"
  ],

api_host: "localhost",
api_port: 8080,
api_scheme: "http"
