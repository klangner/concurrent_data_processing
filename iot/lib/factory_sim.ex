defmodule FactorySim do

  def start_link() do
    spawn(&run/0)
  end

  def run() do
    {:ok, connection} = AMQP.Connection.open
    {:ok, channel} = AMQP.Channel.open(connection)
    AMQP.Exchange.declare(channel, "readings", :fanout)

    tick(channel)
  end

  def tick(channel) do
    message = "TE_1205"
    AMQP.Basic.publish(channel, "readings", "", message)

    Process.sleep(1_000)
    tick(channel)
  end
end
