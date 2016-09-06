defmodule LoggerLedBackend.Mixfile do

  @version "0.1.0"

  use Mix.Project

  def project do
    [ app: :logger_led_backend,
      version: @version,
      elixir: "~> 1.0",
      deps: deps(),
      description: "Adds backend to Logger that blinks an LED",
      package: package(),
      name: "LoggerLedBackend",
      description: "Flashes LED when log events meeting level received",
      docs: [
        source_ref: "v#{@version}", main: "LoggerLedBackend",
        source_url: "https://github.com/CaptChrisD/logger_led_backend",
#       main: "extra-readme",
        extras: [ "README.md", "CHANGELOG.md"] ]]
  end

  def application do
    []
  end

  defp deps, do: [
    {:ex_doc, "~> 0.11", only: :dev},
    {:nerves_leds, "~>0.7.0"}
  ]

  defp package do
    [ maintainers: ["Chris Dutton"],
      licenses: ["MIT"],
      links: %{github: "https://github.com/CaptChrisD/logger_led_backend"},
      files: ~w(lib config) ++ ~w(README.md CHANGELOG.md LICENSE mix.exs) ]
  end

end
