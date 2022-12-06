defmodule StreamReader do
  use GenServer, restart: :transient

  defstruct [:source, :connection]


  def connect_rabbit(exchange) do
    GenServer.start_link(__MODULE__, %{source: "rabbitmq", exchange: exchange})
  end


  def init(%{source: "rabbitmq"} = args) do
    {:ok, connection} = AMQP.Connection.open
    {:ok, channel} = AMQP.Channel.open(connection)

    AMQP.Exchange.declare(channel, args.exchange, :fanout)
    {:ok, %{queue: queue_name}} = AMQP.Queue.declare(channel, "", exclusive: true)
    AMQP.Queue.bind(channel, queue_name, args.exchange)
    AMQP.Basic.consume(channel, queue_name, nil, no_ack: true)

    state = %StreamReader{source: args.source, connection: connection}
    {:ok, state}
  end


  def terminate(_reason, state) do
    AMQP.Connection.close(state.connection)
  end

  def handle_info({:basic_deliver, payload, _meta}, state) do
    IO.puts("[x] Received message: #{payload}")
    {:noreply, state}
  end

  def handle_info(_args, state) do
    {:noreply, state}
  end
end
