use Mix.Config

config :nerves_leds,
         names: [ test_led: &LoggerLedBackendTest.on_led_write/1 ],
         states: [
           true: [brightness: 1],
           false: [brightness: 0],
           slowblink: [trigger: "timer", delay_off: 250, delay_on: 250],
           fastblink: [trigger: "timer", delay_off: 80, delay_on: 50],
           slowwink: [trigger: "timer", delay_on: 1000, delay_off: 100],
           heartbeat: [trigger: "heartbeat"],
           test_state: [foo: 3, bar: 29, baz: %{}]]

config :logger_led_backend, led: :test_led