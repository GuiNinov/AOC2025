defmodule Aoc.MixProject do
  use Mix.Project

  def project do
    [
      app: :aoc,
      version: "0.1.0",
      elixir: "~> 1.17",
      escript: [main_module: Aoc],
      start_permanent: Mix.env() == :prod,
      deps: []
    ]
  end

end
