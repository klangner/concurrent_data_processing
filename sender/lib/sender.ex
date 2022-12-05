defmodule Sender do
  @moduledoc """
  Documentation for `Sender`.
  """

  def send_email("konnichiwa@world.com" = _email), do: :error

  def send_email(email) do
    Process.sleep(3_000)
    IO.puts("Email to #{email} sent")
    {:ok, "email sent"}
  end

  def notify_all(emails) do
    Sender.EmailTaskSupervisor
    |> Task.Supervisor.async_stream_nolink(emails, &send_email/1)
    |> Enum.to_list()
  end
end
