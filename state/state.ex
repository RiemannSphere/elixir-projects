defmodule State do
  def receive() do
    receive do
      {:val, val} -> IO.puts("Received value: #{val}")
      {:map, map} -> IO.puts("Received state: #{inspect(map)}")
    end
  end

  def create_state() do
    {:ok, pid} = Task.start_link(fn -> state(%{}) end)
    pid
  end

  defp state(map) do
    receive do 
      {:put, key, value} -> 
        state(map |> Map.put(key, value))
      {:get, key, caller_pid} -> 
        send(caller_pid, {:val, map |> Map.get(key)})
        state(map)
      {:all, caller_pid} ->
        send(caller_pid, {:map, map})
        state(map)
    end
  end
end

state = State.create_state()
send(state, {:put, 1, "dupa 1"})
send(state, {:put, 2, "dupa 2"})
send(state, {:put, 3, "dupa 3"})
send(state, {:get, 1, self()})
State.receive()


