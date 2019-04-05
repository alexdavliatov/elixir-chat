defmodule ChatTest do
  use ExUnit.Case
  alias Chat.Map, as: Chat

  doctest Chat

  setup do
    app = start_supervised!(Chat)
    %{app: app}
  end

  test "should keep first message", %{app: app} do
    assert Chat.search(app, 1) == {:ok, %{}}

    Chat.send(app, 1, 2, "hi")
    assert Chat.search(app, 1) == {:ok, %{2 => ["hi"]}}
  end

  test "should accumulate messages", %{app: app} do
    assert Chat.search(app, 1) == {:ok, %{}}

    Chat.send(app, 1, 2, "hi")
    Chat.send(app, 1, 2, "hello")

    assert Chat.search(app, 1) == {:ok, %{2 => ["hi", "hello"]}}
  end
end
