defmodule ChatTest do
  use ExUnit.Case
  doctest Chat.Ets

  alias Chat.Ets, as: Chat

  setup do
    app = start_supervised!(Chat)
    %{app: app}
  end

  test "should keep first message", %{app: app} do
    assert Chat.search(app, 1) == {:ok, %{}}

    Chat.send(app, 1, 2, "hi")

    :sys.get_state(app)

    assert Chat.search(app, 1) == {:ok, %{2 => ["hi"]}}
    assert :ets.lookup(:messages, 1) == [{1, 2, ["hi"]}]
  end

  test "should accumulate messages", %{app: app} do
    assert Chat.search(app, 1) == {:ok, %{}}

    Chat.send(app, 1, 2, "hi")
    Chat.send(app, 1, 2, "hello")
    # wait for async cast finish
    :sys.get_state(app)

    assert Chat.search(app, 1) == {:ok, %{2 => ["hi", "hello"]}}
    assert :ets.lookup(:messages, 1) == [{1, 2, ["hi", "hello"]}]
  end
end
