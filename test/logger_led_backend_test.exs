defmodule LoggerLedBackendTest do
  use ExUnit.Case
  require Logger

  #IMPORTANT: These tests should be improved. Sometimes they will fail due to
  #how logger events are triggered/processed. There is a sleep in each test
  #to help with this, but is not fool proof.

  Logger.add_backend LoggerLedBackend

  setup_all do
    :ets.new :logger_test, [:named_table, :set, :public]
    :ok
  end

  # callback for the test led that simply sets keys in and ets table
  def on_led_write({k, v}) do
    :ets.insert :logger_test, [{k, v}]
  end

  test "valid event - error" do
    Logger.error "Test"
    sleep()
    assert check(:brightness) == 1
    :ets.insert :logger_test, brightness: 0
  end

  test "invalid event - debug" do
    Logger.debug "Debug Test"
    sleep()
    assert check(:brightness) == 0
    :ets.insert :logger_test, brightness: 0
  end

  test "invalid then valid - debug" do
    Logger.debug "Debug Test"
    sleep()
    assert check(:brightness) == 0
    Logger.configure_backend LoggerLedBackend, [level: :debug]
    :timer.sleep(500)
    Logger.debug "Debug Test"
    sleep()
    assert check(:brightness) == 1
    :ets.insert :logger_test, brightness: 0
  end

  defp check(key) do
    case :ets.lookup(:logger_test, key) do
      [] -> nil
      [{_, v}] -> v
    end
  end

  defp sleep() do
    :timer.sleep 15 #sleep to let Logger process event
  end
end
