defmodule LoggerLedBackend.Mixfile do

  @version "2.0.0"

  use Mix.Project

  def project do
    [ app: :logger_led_backend,
      version: @version,
      elixir: "~> 1.11",
      deps: deps(),
      description: description(),
      package: package(),
      name: "LoggerLedBackend",
      docs: [
        source_ref: "v#{@version}", main: "LoggerLedBackend",
        source_url: "https://github.com/CaptChrisD/logger_led_backend",
        extras: [ "README.md", "CHANGELOG.md"] ]]
  end

  def application do [
    applications: [:logger, :nerves_leds]
    ]
  end

  defp description do
    "A backend for Logger that Flashes LED when log events meeting level received"
  end

  defp deps, do: [
    {:ex_doc, "~> 0.23"},
    {:nerves_leds, "~>0.8.1"}
  ]

  defp package do
    [ maintainers: ["Rose Point"],
      licenses: ["MIT"],
      links: %{github: "https://github.com/rosepointnav/logger_led_backend"},
      files: ~w(lib config) ++ ~w(README.md CHANGELOG.md LICENSE mix.exs) ]
  end

end
