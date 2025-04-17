defmodule AlchemistLibrary.MixProject do
  use Mix.Project

  def project do
    [
      app: :alchemist_library,
      version: "0.1.0",
      elixir: "~> 1.18",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {AlchemistLibrary.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ecto_sql, "~> 3.10"},
      {:postgrex, "~> 0.17"},
      {:paginator, "~> 1.2.0"},
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
      {:cowboy, "~> 2.6"},
      {:plug, "~> 1.7"},
      {:plug_cowboy, "~> 2.0"},
      {:jason, "~> 1.4"}
    ]
  end
end
