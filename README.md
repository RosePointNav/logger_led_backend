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

By default the `:error` led will be turned on for 100ms and then extinquished when an `Logger.error` event is received.

The user may adjust the `Logger` level causing trigger, on time and what `Nerves.Led` name to use in the applications config

```elixir
  #in config/config/exs
  config :logger_led_backend, level: :info, on_time: 50, led: :power
```
