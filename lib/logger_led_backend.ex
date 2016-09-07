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

  `:led` - the `Nerves.Leds` led name to flash when an event is received (default: :error)

  `:led_pull` - direction to pull led `:on | :off` (default: :on)

  `:on_time` - how long to keep the led_pull active when event received (default: 50)

  `:level` - the lowest level which triggers the LED. (default: :info)

  Configuration may also be conducted using `Logger.configure_backends/2`
  """

  use GenEvent
  require Logger

  @min_level  Application.get_env(:logger_led_backend, :level, :info)
  @led        Application.get_env(:logger_led_backend, :led, :error)
  @led_pull  Application.get_env(:logger_led_backend, :led_pull, :on)
  @on_time    Application.get_env(:logger_led_backend, :on_time, 50)

  @defaults %{level: @min_level, led: @led, led_pull: @led_pull, on_time: @on_time}

  @doc false
  def init({__MODULE__, opts}) do
    config = configure(opts, @defaults)
    Logger.debug "#{__MODULE__} Starting for led #{inspect config.led} with #{inspect config}"
    {:ok, config}
  end

  def init(__MODULE__), do: init({__MODULE__, []})

  def handle_call({:configure, options}, state) do
    {:ok, :ok, configure(options, state)}
  end

  @doc false
  def handle_event({level, _gl, {Logger, _message, _timestamp, _metadata}}, %{level: min_level, led: led, on_time: time, led_pull: pull} = state) do
    if ((is_nil(min_level) or Logger.compare_levels(level, min_level) != :lt) and led), do: spawn(fn() -> blink(led, time, pull) end)
    {:ok, state}
  end

  def handle_event(:flush, state) do
    {:ok, state}
  end

  defp configure(opts, defaults) do
    level = Dict.get(opts, :level, defaults.level)
    led = Dict.get(opts, :led, defaults.led)
    led_level = Dict.get(opts, :led_level, defaults.led_pull)
    on_time = Dict.get(opts, :on_time, defaults.on_time)
    %{level: level, led: led, led_pull: led_level, on_time: on_time}
  end

  defp blink(led, time, :on) do
    Nerves.Leds.set [{led, true}]
    :timer.sleep time
    Nerves.Leds.set [{led, false}]
  end

  defp blink(led, time, :off) do
    Nerves.Leds.set [{led, false}]
    :timer.sleep time
    Nerves.Leds.set [{led, true}]
  end
end
