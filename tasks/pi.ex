defmodule Pi do
  @moduledoc """
  Use this module to find out if parallel computing makes Monte Carlo
  computations faster. 
  As an example we calculate the value of Pi.
  """

  # Non-parallel:
  # 1. generate N points (x,y)
  # 2. count points inside the circle
  # 3. calculate Pi
  # Parallel:
  # 1. start N tasks, every task generating a point (x,y)
  # 2. await task values and count points on the circle
  # 3. calculate Pi

  @n 100_000 

  def parallel() do
    count_points_parallel([], @n) 
    |> Task.await_many
    |> Enum.filter(fn in_circle? -> in_circle? == true end)
    |> Enum.count
    |> calculate_pi  
  end

  defp count_points_parallel(tasks, n) do
    if n == 0 do
      tasks
    else
      task = Task.async(fn -> in_circle?() end)
      count_points_parallel([task | tasks], n - 1)
    end
  end

  defp in_circle?() do
    gen_point() |> to_distance() <= 1
  end

  def non_parallel() do
    points_in_circle = gen_points([], @n)
    |> Enum.map(fn p -> to_distance(p) end)
    |> Enum.filter(fn d -> d <= 1 end)
    |> Enum.count()
    calculate_pi(points_in_circle)
  end

  defp calculate_pi(points_in_circle) do
    4 * points_in_circle / @n
  end

  defp to_distance(point) do
    point.x ** 2 + point.y ** 2
  end

  defp gen_points(points, n) do
    if n == 0 do
      points
    else
      gen_points([gen_point() | points], n - 1)
    end
  end

  defp gen_point() do
    # [0,1] x [0,1] because quarter of a circle is good enough
    x = :rand.uniform()
    y = :rand.uniform()
    %{x: x, y: y}
  end
end

#:timer.tc(Pi, :non_parallel, [])
#:timer.tc(Pi, :parallel, [])
