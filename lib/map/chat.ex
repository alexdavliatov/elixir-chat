# defmodule ChatBehaviour do
#   @typedoc """
#   Ecto.UUID type
#   """
#   @type uuid() :: Ecto.UUID

#   @callback search(pid, uuid()) :: map()
#   @callback send(pid, uuid(), uuid(), %Message{}) :: nil
# end

defmodule Chat.Map do
  use GenServer

  # @behaviour ChatBehaviour
  @typedoc """
  Ecto.UUID type
  """
  @type uuid() :: Ecto.UUID

  @moduledoc """
  Documentation for Chat.
  """

  @doc """
  Starts chat server.
  """
  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  @doc """
  Starts chat server.
  """
  def stop(server) do
    GenServer.stop(server)
  end

  @doc """
  Searches for `messages` sent to `user`.

  Returns `{:ok, pid}` if the bucket exists, `:error` otherwise.
  """
  # @impl ChatBehaviour
  @spec search(pid, uuid()) :: map()
  def search(server, user_id) do
    GenServer.call(server, {:search, user_id})
  end

  @doc """
  Sends `message` `from` user `to` user.

  Returns `{:ok, pid}` if the bucket exists, `:error` otherwise.
  """
  # @impl ChatBehaviour
  @spec send(pid, uuid(), uuid(), %Message{})::any()
  def send(server, to, from, message) do
    GenServer.cast(server, {:send, to, from, message})
  end

  @doc """
  Searches for `messages` sent to `user`.

  Returns `{:ok, pid}` if the bucket exists, `:error` otherwise.
  """
  def all(server) do
    GenServer.call(server, {:all})
  end


  ## Callbacks
  def init(:ok) do
    {:ok, %{}}
  end

  def handle_call({:search, user_id}, _from, messages) do
    {:reply, {:ok, Map.get(messages, user_id, %{})}, messages}
  end

  def handle_call({:all}, _from, messages) do
    {:reply, {:ok, messages}, messages}
  end

  def handle_cast({:send, to, from, message}, messages) do
    if Map.has_key?(messages, to) do
      {_prev, messages} = Map.get_and_update(messages, to, fn ms -> store_chat_message(ms, from, message) end)
      {:noreply, messages}
    else
      messages = Map.put_new(messages, to, %{from => [message]})
      {:noreply, messages}
    end
  end

  defp store_chat_message(messages, from, message) do
    if Map.has_key?(messages, from) do
      Map.get_and_update(messages, from, fn ms -> {ms, ms ++ [message]} end)
    else
      messages = Map.put_new(messages, from, [message])
      {nil, messages}
    end
  end
end
