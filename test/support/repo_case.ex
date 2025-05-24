defmodule Library.RepoCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      alias Library.Repo

      import Ecto
      import Ecto.Query
      import Library.RepoCase
    end
  end

  setup tags do
    pid = Ecto.Adapters.SQL.Sandbox.start_owner!(Library.Repo, shared: not tags[:async])
    on_exit(fn -> Ecto.Adapters.SQL.Sandbox.stop_owner(pid) end)
    :ok
  end
end
