defmodule LoggerLedBackend do
  @moduledoc """
  A `Logger` backend that flashes an LED when an event is received matching the configured
  log level. Originally designed for embedded applications, it allows easily watching the
  LED to see if log events of concern are being logged.

  In your config, simply do something like this:

  ```elixir
    config :logger_led_backend, level: :error, led: :error
  ```

  LoggerLedBackend is configured when specified, and supports the following options:

  `:led` - the led to flash when an event is received

  `:on_time` - how long to keep the led on when event received

  `:level` - the lowest level which triggers the LED.
  """

  use GenEvent
  require Logger

  @min_level  Application.get_env(:logger_led_backend, :level, :info)
  @led        Application.get_env(:logger_led_backend, :led, :error)
  @on_time    Application.get_env(:logger_led_backend, :rate, 100)

  @doc false
  def init({__MODULE__, opts}) do
    Logger.debug "#{__MODULE__} Starting for led #{inspect @led}"
    {:ok, %{}}
  end

  def init(__MODULE__), do: init({__MODULE__, []})

  @doc false
  def handle_event({level, _gl, {Logger, message, timestamp, metadata}}, _state) do
    if ((is_nil(@min_level) or Logger.compare_levels(level, @min_level) != :lt) and @led), do: spawn(&blink/0)
    {:ok, %{}}
  end

  defp blink do
    Nerves.Leds.set [{@led, true}]
    :timer.sleep @on_time
    Nerves.Leds.set [{@led, false}]
  end
end
