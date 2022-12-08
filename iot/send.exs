{:ok, connection} = AMQP.Connection.open
{:ok, channel} = AMQP.Channel.open(connection)

message =
  case System.argv do
    []    -> "Hello World!"
    words -> Enum.join(words, " ")
  end

AMQP.Exchange.declare(channel, "readings", :fanout)
AMQP.Basic.publish(channel, "readings", "", message)
IO.puts " [x] Sent '#{message}'"

AMQP.Connection.close(connection)
