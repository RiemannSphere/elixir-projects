defmodule Parallel do
  @moduledoc """
    An API to run generic tasks in parallel in different setups.
    Run tasks synchronously, in batches of different size or even
    every task in separate process and analyse the performance differences.
  """

  @doc """
    Run task n_tasks times in n_batches batches, collect results, and reduce them 
    using reduce_fun function. 
  """
  def run(task, n_batches, n_tasks, reduce_fun) do
    
  end
end
