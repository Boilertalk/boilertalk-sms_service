require 'rubygems'
require 'bundler'
Bundler.require(:default)

# Setup LEDs
led1 = PiPiper::Pin.new(pin: 16, direction: :out)
led2 = PiPiper::Pin.new(pin: 18, direction: :out)
led3 = PiPiper::Pin.new(pin: 22, direction: :out)
# End Setup LEDs

SERIAL_PORT = '/dev/ttyAMA0'.freeze

serialport = Serial.new SERIAL_PORT, 115_200
puts 'Setup complete...'
