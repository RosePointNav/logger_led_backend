defmodule LoggerLedBackendTest do
  use ExUnit.Case, async: true
  require Logger

  # TODO: Fix tests
  #
  # IMPORTANT: These tests should be improved. Sometimes they will fail due to
  # how logger events are triggered/processed. There is a sleep in each test
  # to help with this, but is not fool proof.
  #
  # Also, the logger blinks on error, so the test for on/off isn't valid

  setup_all do
    Logger.add_backend LoggerLedBackend
    :ets.new :logger_test, [:named_table, :set, :public]
    reset_test_led()
    :ets.insert :logger_test, trigger: :none
    :timer.sleep(100)
    :ok
  end

  defp reset_test_led do
    :ets.insert :logger_test, brightness: 0
  end

  # callback for the test led that simply sets keys in and ets table
  def on_led_write({k, v}) do
    #IO.puts "on_led_write: #{k} #{v}"
    :ets.insert :logger_test, [{k, v}]
  end


  @tag :LoggerLedBackendTest1
  test "valid event - error" do
    Logger.error "Valid Event Test"
    sleep()
    :timer.sleep(1000)
    assert check(:brightness) == 1
    reset_test_led()
  end

  @tag :LoggerLedBackendTest
  test "invalid event - debug" do
    Logger.debug "Invalid Event Test"
    sleep()
    assert check(:brightness) == 0
    reset_test_led()
  end

  @tag :LoggerLedBackendTest
  test "invalid then valid - debug" do
    Logger.debug "Debug Test Before Level Set"
    sleep()
    assert check(:brightness) == 0
    Logger.configure_backend LoggerLedBackend, [level: :debug]
    :timer.sleep(1000)
    Logger.debug "Debug Test After Level Set"
    sleep()
    assert check(:brightness) == 1
    reset_test_led()
  end

  @tag :LoggerLedBackendTest
  test "turn off led via configure_backend" do
    Nerves.Leds.set test_led: true
    assert check(:brightness) == 1

    Logger.configure_backend LoggerLedBackend, [led_level: :off]
    sleep()
    assert check(:brightness) == 0
    reset_test_led()
  end

  @tag :LoggerLedBackendTest
  test "turn on led via configure_backend" do
    Nerves.Leds.set test_led: false
    assert check(:brightness) == 0

    Logger.configure_backend LoggerLedBackend, [led_level: :on]
    sleep()
    assert check(:brightness) == 1
    reset_test_led()
  end

  defp check(key) do
    #IO.puts "check key: #{key}"
    case :ets.lookup(:logger_test, key) do
      [] -> nil
      [{_, v}] -> v
    end
  end

  defp sleep() do
    :timer.sleep 75 #sleep to let Logger process event
  end
end
