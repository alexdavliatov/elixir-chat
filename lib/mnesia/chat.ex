defmodule Chat.Mnesia do
  alias :mnesia, as: Mnesia
  @moduledoc """
  Documentation for Chat.
  """

  @doc """
  Starts chat server.

  `:name` is always required.
  """
  def start() do
    Mnesia.create_schema([node()])
    Mnesia.create_table(Message, [attributes: Keyword.keys(IdentifiedMessage.fields())])
    Mnesia.start()
    Mnesia.wait_for_tables([Messages], 5000)
  end

  @doc """
  Stops chat server.
  """
  def stop(server) do
    GenServer.stop(server)
    Mnesia.stop()
  end

  @doc """
  Searches for `messages` sent to `user`.
  """
  def search(to) do
    Mnesia.transaction(fn ->
      Mnesia.match_object({Messages, :_, to, :_})
    end)
  end

  @doc """
  Sends `message` `from` user `to` user.
  """
  def send(to, from, message) do
    Mnesia.transaction(fn ->
      case Mnesia.match_object({Messages, :_, to, :_}) do
        [] -> Mnesia.write({Messages, from, to, [message]})
        [{_, _, _, messages}] -> Mnesia.write({Messages, from, to, messages ++ [message]})
      end
    end)

  end
end
