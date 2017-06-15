require 'rubygems'
require 'bundler'
Bundler.require(:default)
# Load environment variables
Dotenv.load

# Monkeypatch Serial
require_relative 'lib/rubyserial_extensions/serial/get_all'
Serial.include RubyserialExtensions::Serial::GetAll
# End Monkeypatch Serial

interrupted = false

# Trap ^C
Signal.trap('INT') do
  puts "\n"
  puts 'Shutting down...'
  interrupted = true
end

# Trap `Kill `
Signal.trap('TERM') do
  puts "\n"
  puts 'Shutting down...'
  interrupted = true
end

# Setup LEDs
led1 = PiPiper::Pin.new(pin: 16, direction: :out)
led2 = PiPiper::Pin.new(pin: 18, direction: :out)
led3 = PiPiper::Pin.new(pin: 22, direction: :out)
# End Setup LEDs

SERIAL_PORT = '/dev/ttyAMA0'.freeze

serialport = Serial.new SERIAL_PORT, 115_200
puts 'Setup complete...'

# Set to text mode
serialport.write "AT+CMGF=1\r"
sleep 1
puts 'Text mode activated...'
# End Set to text mode

# Setup Redis
host = ENV['REDIS_HOST']
port = ENV['REDIS_PORT']
password = ENV['REDIS_PASSWORD']
redis = Redis.new(host: host, port: port, password: password)

redis.set('mykey', 'hello world')
