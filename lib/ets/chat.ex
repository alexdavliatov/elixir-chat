defmodule Chat.Ets do
  use GenServer

  @moduledoc """
  Documentation for Chat.
  """

  @doc """
  Starts chat server.

  `:name` is always required.
  """
  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, opts)
  end

  @doc """
  Stops chat server.
  """
  def stop(server) do
    GenServer.stop(server)
  end

  @doc """
  Searches for `messages` sent to `user`.
  """
  def search(_, to) do
    {:ok,
     :ets.match(:messages, {to, :"$2", :"$3"})
     |> Stream.map(fn list -> {hd(list), hd(tl(list))} end)
     |> Map.new()}
  end

  @doc """
  Sends `message` `from` user `to` user.
  """
  def send(server, to, from, message) do
    GenServer.cast(server, {:send, to, from, message})
  end

  ## Callbacks
  def init(_) do
    messages = :ets.new(:messages, [:named_table, read_concurrency: true])

    {:ok, messages}
  end

  def handle_cast({:send, to, from, message}, messages) do
    {:ok, messages_by_sender} = search(messages, to)
    ms = Map.get(messages_by_sender, from, [])
    :ets.insert(messages, {to, from, ms ++ [message]})

    {:noreply, messages}
  end
end

# alias Chat.Ets, as: Chat
# {:ok, pid} = Chat.start_link([])
# Chat.send(pid, 1, 2, "Hi")
