defmodule UdpTest do
  use ExUnit.Case
  doctest Udp

  test "greets the world" do
    assert Udp.hello() == :world
  end
end
