defmodule AttrAccessor.MixProject do
  use Mix.Project

  def project do
    [
      app: :attr_accessor,
      version: "0.1.0",
      elixir: "~> 1.18",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      docs: docs(),
      licenses: "MIT",
      source_url: "https://github.com/madlep/elixir_attr_accessor"
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:ex_doc, "~> 0.37", only: :dev, runtime: false}
    ]
  end

  defp docs do
    [
      main: "README",
      extras: ["README.md"]
    ]
  end
end
