defmodule SupervisorExampleAppTest do
  use ExUnit.Case
  doctest SupervisorExampleApp

  test "adds named process to supervisor correctly" do
    # We can create named global agents
    assert {:ok, named_global_agent} = Agent.start_link(fn -> %{hi: "hello"} end, name: {:global, "agent_name_001"})

    # We can get their state
    assert %{hi: "hello"} = Agent.get(named_global_agent, & &1)

    # Now I want to add that agent to a supervision tree
    # We start by creating a DynamicSupervisor
    {:ok, dyn_sup} = DynamicSupervisor.start_link(DynamicSupervisor, strategy: :one_for_one, name: :dyn_sup)

    # Now we add the named_global_agent to the DynamicSupervisor supervision's
    # tree.
    # Prepare the child_spec map
    child_spec = %{
      id: "new agent",
      # This works, `start_child/2` works with this map
      # start: {Agent, :start_link, [fn -> %{im_global: true} end]},
      # This does not work. `start_child/2` does not work with this map
      start: {Agent, :start_link, [fn -> %{im_global: true} end, name: {:global, "im global child spec"}]},
      shutdown: 5_000,
      restart: :permanent,
      type: :worker,
    }

    # Based on the `start` config above, the below fails
    assert {:ok, child} = DynamicSupervisor.start_child(dyn_sup, child_spec)

    # Agent exists, we can get its state, all good
    assert %{im_global: true} = Agent.get(child, & &1)

    # I want the following to work eventually
    assert %{im_global: true} = Agent.get("im global child spec", & &1)
  end
end
