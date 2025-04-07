defmodule AttrAccessor.MixProject do
  use Mix.Project

  def project do
    [
      app: :attr_accessor,
      version: "0.1.0",
      elixir: "~> 1.18",
      start_permanent: Mix.env() == :prod,
      description: description(),
      deps: deps(),
      docs: docs(),
      package: package(),
      source_url: "https://github.com/madlep/elixir_attr_accessor"
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp description do
    "Ruby style attr_accessor macros to generate functions to read/update/write struct fields"
  end

  defp deps do
    [
      {:ex_doc, "~> 0.37", only: :dev, runtime: false}
    ]
  end

  defp docs do
    [
      main: "AttrAccessor",
      extras: ["README.md"]
    ]
  end

  defp package() do
    [
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/madlep/elixir_attr_accessor"}
    ]
  end
end
