defmodule Yatm.MixProject do
  use Mix.Project

  @version "0.1.0"
  @source_url "https://github.com/raulrpearson/yatm"

  def project do
    [
      app: :yatm,
      version: @version,
      elixir: "~> 1.18",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: [
        maintainers: ["Raúl R. Pearson"],
        licenses: ["BlueOak-1.0.0"],
        links: %{"GitHub" => @source_url}
      ],
      name: "Yatm",
      description: "A Tailwind class merging utility",
      source_url: @source_url,
      docs: [
        authors: ["Raúl R. Pearson"],
        canonical: "https://hexdocs.pm/yatm",
        extras: [
          "README.md",
          "LICENSE.md": [filename: "license", title: "License", source: "LICENSE.md"]
        ],
        main: "readme",
        source_ref: "v#{@version}",
      ]
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:nimble_parsec, "~> 1.0"},
      {:ex_doc, "~> 0.34", only: :dev, runtime: false}
    ]
  end
end
