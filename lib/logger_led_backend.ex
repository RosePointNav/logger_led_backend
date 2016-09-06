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

  `:led` - the led to flash when an event is received (default: :error)

  `:on_time` - how long to keep the led on when event received (default: 50)

  `:level` - the lowest level which triggers the LED. (default: :info)

  Configuration may also be conducted using `Logger.configure_backends/2`
  """

  use GenEvent
  require Logger

  @min_level  Application.get_env(:logger_led_backend, :level, :info)
  @led        Application.get_env(:logger_led_backend, :led, :error)
  @on_time    Application.get_env(:logger_led_backend, :on_time, 50)

  @doc false
  def init({__MODULE__, opts}) do
    level = Dict.get(opts, :level, @min_level)
    led = Dict.get(opts, :led, @led)
    on_time = Dict.get(opts, :on_time, @on_time)
    Logger.debug "#{__MODULE__} Starting for led #{inspect led}"
    {:ok, %{level: level, led: led, on_time: on_time}}
  end

  def init(__MODULE__), do: init({__MODULE__, []})

  def handle_call({:configure, options}, %{level: l, led: led, on_time: time} = _state) do
    level = Dict.get(options, :level, l)
    led = Dict.get(options, :led, led)
    on_time = Dict.get(options, :on_time, time)
    {:ok, :ok, %{level: level, led: led, on_time: on_time}}
  end

  @doc false
  def handle_event({level, _gl, {Logger, _message, _timestamp, _metadata}}, %{level: min_level, led: led, on_time: time} = state) do
    if ((is_nil(min_level) or Logger.compare_levels(level, min_level) != :lt) and led), do: spawn(fn() -> blink(led, time) end)
    {:ok, state}
  end

  def handle_event(:flush, state) do
    {:ok, state}
  end

  defp blink(led, time) do
    Nerves.Leds.set [{led, true}]
    :timer.sleep time
    Nerves.Leds.set [{led, false}]
  end
end
