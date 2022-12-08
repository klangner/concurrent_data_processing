defmodule Iot.Application do

  use Application

  @impl true
  def start(_type, _args) do

    FactorySim.start_link()

    children = [
    ]
    opts = [strategy: :one_for_one, name: Iot.Supervisor]
    Supervisor.start_link(children, opts)

  end
end
