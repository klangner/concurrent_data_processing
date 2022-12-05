defmodule SendServer do
  use GenServer

  def init(args) do
    IO.puts("Received arguments: #{inspect(args)}")
    max_retries = Keyword.get(args, :max_retries, 5)
    state = %{emails: [], max_retries: max_retries}
    Process.send_after(self(), :retry, 5000)
    {:ok, state}
  end

  def handle_info(:retry, state) do
    IO.puts("Handle info emails: #{inspect(state.emails)}")
    {failed, done} = Enum.split_with(state.emails, fn item ->
      item.status == "failed" and item.retries < state.max_retries
    end)
    new_failed = Enum.map(failed, fn item ->
        new_status = case Sender.send_email(item.email) do
          {:ok, _} -> "sent"
          :error -> "failed"
        end
        %{email: item.email, status: new_status, retries: item.retries + 1}
      end)
    Process.send_after(self(), :retry, 5000)
    {:noreply, %{state | emails: done ++ new_failed}}
  end

  def handle_call(:get_state, _from, state) do
    {:reply, state, state}
  end

  def handle_cast({:send, email}, state) do
    status = case Sender.send_email(email) do
      {:ok, _} -> "sent"
      :error -> "failed"
    end
    emails = [%{email: email, status: status, retries: 0} | state.emails]
    new_state = %{state | emails: emails}
    {:noreply, new_state}
  end

  def terminate(reason, _state) do
    IO.puts("Terminate with reson #{reason}")
  end
end
