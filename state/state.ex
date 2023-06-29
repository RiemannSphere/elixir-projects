defmodule State do
  def create_state() do
    {:ok, pid} = Task.start_link(fn -> state(%{}) end)
    pid
  end

  defp state(map) do
    receive do 
      {:put, key, value} -> 
        state(map |> Map.put(key, value))
      {:get, key, caller_pid} -> 
        send(caller_pid, map |> Map.get(key))
        state(map)
      {:all, caller_pid} ->
        send(caller_pid, map)
        state(map)
    end
  end
end
