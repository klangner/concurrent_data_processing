message =
  case System.argv do
    []    -> "Hello World!"
    words -> Enum.join(words, " ")
  end

{:ok, connection} = AMQP.Connection.open
{:ok, channel} = AMQP.Channel.open(connection)
AMQP.Queue.declare(channel, "hello")

AMQP.Basic.publish(channel, "", "hello", message)

AMQP.Connection.close(connection)
