defmodule Plivo.Mixfile do
  use Mix.Project

  def project do
    [
      app: :ex_plivo,
      version: "0.1.1",
      build_path: "_build",
      config_path: "config/config.exs",
      deps_path: "deps",
      lockfile: "mix.lock",
      elixir: "~> 1.5.2",
      start_permanent: Mix.env == :prod,
      deps: deps(),
      description: description(),
      package: package(),
      source_url: "https://github.com/raen79/plivo"
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :httpoison]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:httpoison, "~> 0.13"},
      {:poison, "~> 3.1"},
      {:ex_doc, ">= 0.0.0", only: :dev}
    ]
  end

  defp description() do
    "An elixir client for the plivo api."
  end

  defp package() do
    [
      licenses: ["MIT"],
      maintainers: ["Eran Peer"],
      links: %{"GitHub" => "https://github.com/raen79/plivo"}
    ]
  end
end
