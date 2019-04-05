import DateTime

alias Ecto.UUID, as: UUID

defmodule Message do
  @moduledoc """
  Basic message structure.
  """
  # @fields [id: UUID.generate(), content: "", created_at: utc_now(), modified_at: utc_now()]
  defstruct id: nil, content: "", created_at: nil, modified_at: nil
  def fields(message), do: [{:id, message.id}, {:content, message.content}, {:created_at, message.created_at}, {:modified_at, message.modified_at}]
  # def fields, do: unquote(Keyword.keys(@fields))
  def new(id \\ UUID.generate(), content, created_at \\ utc_now(), modified_at \\ utc_now()) do
    %Message{:id => id, :content => content, :created_at => created_at, :modified_at => modified_at}
  end
end

defmodule IdentifiedMessage do
  @moduledoc """
  Basic message structure.
  """
  # @fields [id: UUID.generate(), content: "", created_at: utc_now(), modified_at: utc_now()]
  @enforce_keys [:from, :to, :message]
  defstruct from: nil, to: nil, message: nil

  def fields(), do: [{:from, nil}, {:to, nil}, {:message, nil}]

  def fields(message), do: [{:from, message.from}, {:to, message.to}, {:message, message.message}]
end

defmodule Party do
  defstruct id: UUID.generate(), chat_id: UUID.generate(), user_id: UUID.generate(), created_at: utc_now(), modified_at: utc_now()
end

defmodule User do
  @enforce_keys :name
  defstruct id: nil, name: nil , origin: nil, ref: nil, created_at: nil, modified_at: nil

  def new(id \\ UUID.generate(), name, origin \\ nil, ref \\ nil, created_at \\ utc_now(), modified_at \\ utc_now()) do
    %User{:id => id, :name => name, :origin => origin, :ref => ref, :created_at => created_at, :modified_at => modified_at}
  end
end

defmodule Group do
  @enforce_keys :name
  defstruct id: UUID.generate(), name: nil , created_at: utc_now(), modified_at: utc_now()
end
