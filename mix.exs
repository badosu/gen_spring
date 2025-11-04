defmodule GenSpring.MixProject do
  use Mix.Project

  def project do
    [
      app: :gen_spring,
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
      mod: {GenSpring.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_json_schema, "~> 0.11"},
      {:jason, "~> 1.4"},
      {:nimble_options, "~> 1.1"},
      {:thousand_island, "~> 1.4"},
      {:typed_struct, "~> 0.3"}
    ]
  end
end
