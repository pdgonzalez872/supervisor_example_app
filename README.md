# SupervisorExampleApp

I'm having an issue with the syntax for adding a process (let's say an Agent)
to a DynamicSupervisor supervision tree.

The issue is that I don't know how to create a map with the correct specs for a
child that support a named global process (Agent in this case, but should work
with process).

```

# Create the DynamicSupervisor.
{:ok, dyn_sup} = DynamicSupervisor.start_link(DynamicSupervisor, strategy: :one_for_one, name: :dyn_sup)

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

# This fails
{:ok, child} = DynamicSupervisor.start_child(dyn_sup, child_spec)

# Proof that the child_spec was created successfully is that we could do:
%{im_global: true} = Agent.get("im global child spec", & &1)
```

Do you have any insight on how I should organize the `args` in the `start` key
in `child_spec`?

Thank you,

Paulo

## Sample app

Here is an example app that showcases the behavior I am talking about. Run `mix
test` and you should see the failure.
