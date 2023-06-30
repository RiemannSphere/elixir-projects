defmodule Parallel do
  @moduledoc """
    An API to run generic tasks in parallel in different setups.
    Run tasks synchronously, in batches of different size or even
    every task in separate process and analyse the performance differences.
  """

  @doc """
    Run task_fun n_tasks times without any parallelisation.
    Used for benchmarking async runs.
  """
  def run_sync(task_fun, n_tasks) do
    :timer.tc(&_run_sync/3, [task_fun, n_tasks, []])
  end

  # Good old loop
  defp _run_sync(task_fun, n_tasks, out) do
    if n_tasks > 0 do
      _run_sync(task_fun, n_tasks - 1, [task_fun.() | out])
    else
      out
    end
  end

  @doc """
    Run task_fun n_tasks times in n_batches batches, and collect results.
    TODO: reduce them using reduce_fun function.
  """
  def run(task_fun, n_batches, n_tasks) do
    :timer.tc(&_run_async/3, [task_fun, n_batches, n_tasks])
  end

  defp _run_async(task_fun, n_batches, n_tasks) do
    # every batch has times_int tasks
    times_int = div(n_tasks, n_batches)
    batches_tasks = _run_batches_async(task_fun, times_int, n_batches, [])
    # remaining batch has times_rem tasks
    times_rem = rem(n_tasks, n_batches)
    last_batch_task = Task.async(fn -> _run_batch(task_fun, times_rem, []) end)
    batches_tasks = [last_batch_task | batches_tasks]

    List.flatten(Task.await_many(batches_tasks))
  end

  # Obtain a list of tasks
  defp _run_batches_async(task_fun, times_int, n_batches, batches_tasks) do
    if n_batches > 0 do
      batch_task = Task.async(fn -> _run_batch(task_fun, times_int, []) end)
      _run_batches_async(task_fun, times_int, n_batches - 1, [batch_task | batches_tasks])
    else
      batches_tasks
    end
  end

  # Obtain a list of results
  defp _run_batch(task_fun, times_int, batch_out) do
    if times_int > 0 do
      _run_batch(task_fun, times_int - 1, [task_fun.() | batch_out])
    else
      batch_out
    end
  end
end

# Test performance of different setups
# task_fun = fn -> %{x: :rand.uniform(), y: :rand.uniform()} end
# n_tasks = 100_000
# elem(:timer.tc(Parallel, :run, [task_fun, 1, n_tasks]), 0)
# elem(:timer.tc(Parallel, :run, [task_fun, 10, n_tasks]), 0)
# elem(:timer.tc(Parallel, :run, [task_fun, 100, n_tasks]), 0)
# elem(:timer.tc(Parallel, :run, [task_fun, 1_000, n_tasks]), 0)
# elem(:timer.tc(Parallel, :run, [task_fun, 10_000, n_tasks]), 0)
# elem(:timer.tc(Parallel, :run, [task_fun, 100_000, n_tasks]), 0)

# Compare to non-parallel loop
# elem(:timer.tc(Parallel, :run_sync, [task_fun, n_tasks]), 0)
