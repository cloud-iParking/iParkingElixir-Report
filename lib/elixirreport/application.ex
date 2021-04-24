defmodule Elixirreport.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    :ets.new(:bands, [:bag, :public, :named_table])

    children = [
      # Starts a worker by calling: Elixirreport.Worker.start_link(arg)
      # {Elixirreport.Worker, arg}
      {Plug.Cowboy, scheme: :http, plug: Api.Router, options: [port: api_port()]},
      {Mongo, [name: :mongo, database: db(), pool_size: 2]}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Elixirreport.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp api_port, do: Application.get_env(:elixirreport, :api_port)
  defp db, do: Application.get_env(:elixirreport, :db_db)

end
