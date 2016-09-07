# LoggerLedBackend

Simple module to blink and LED when a log event is received at or above the log level specified in the config.

Uses [`Nerves.Leds`](https://github.com/nerves-project/nerves_leds) to control the LED which relies on the linux led subsystem.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add `logger_led_backend` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:logger_led_backend, "~> 0.1.0"}]
    end
    ```

  2. Ensure `logger_led_backend` is started before your application:

    ```elixir
    def application do
      [applications: [:logger_led_backend]]
    end
    ```

## Configuration

  In your config, simply do something like this:

  ```elixir
    config :logger_led_backend, level: :error, led: :error
  ```

  LoggerLedBackend is configured when specified, and supports the following options:

  `:led` - the `Nerves.Leds` led name to flash when an event is received (default: :error)

  `:led_pull` - direction to pull led `:on | :off` (default: :on)

  `:on_time` - how long to keep the led_pull active when event received (default: 50)

  `:level` - the lowest level which triggers the LED. (default: :info)

  Configuration may also be conducted using `Logger.configure_backends/2`
