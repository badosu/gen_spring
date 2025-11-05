defmodule GenSpring.MixProject do
  use Mix.Project

  def project do
    [
      app: :gen_spring,
      version: "0.1.0",
      elixir: "~> 1.18",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      elixirc_paths: elixirc_paths(Mix.env()),
      aliases: [test: "test --no-start"]
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
    ] ++ test_deps()
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp test_deps do
    [
      {:mimic, "~> 2.0", only: :test}
    ]
  end
end
