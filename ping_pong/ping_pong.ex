defmodule PingPong do

  def create_ping_pong() do
    pong_pid = create_pong()
    spawn(fn -> ping(pong_pid)end)
  end

  def ping(pong_pid) do
    receive do
      _ -> run_ping(pong_pid)
    end
    ping(pong_pid)
  end

  defp run_ping(pong_pid) do
    IO.puts("ping!")
    send(pong_pid, :ok)
  end

  def create_pong() do
    spawn(fn -> pong() end)
  end

  def pong() do
    receive do
      _ -> run_pong() 
    end
    pong()
  end

  defp run_pong() do
    IO.puts("pong!")
  end
end

ping_pong_pid = PingPong.create_ping_pong()
send(ping_pong_pid, :ok)
