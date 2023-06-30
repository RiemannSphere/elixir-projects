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

  @n 100 

  def non_parallel() do
    gen_points([], @n)
    |> Enum.map(fn p -> to_distance(p) end)
  end

  defp to_distance(point) do
    p[]
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
    x = :random.uniform()
    y = :random.uniform()
    %{:x -> x, y: -> y}
  end
end
