defmodule SupervisorExampleAppTest do
  use ExUnit.Case
  doctest SupervisorExampleApp

  test "greets the world" do
    assert SupervisorExampleApp.hello() == :world
  end
end
