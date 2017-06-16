require_relative 'lib/sms_service'

# ******* Constants *******
LED1 = 23
LED2 = 24
LED3 = 25

SERIAL_PORT = '/dev/ttyAMA0'.freeze
SERIAL_BAUD_RATE = 115_200
# ******* End Constants *******

interrupted = false

# Trap ^C
Signal.trap('INT') do
  puts "\n"
  puts 'Shutting down...'
  interrupted = true
end

# Trap `Kill`
Signal.trap('TERM') do
  puts "\n"
  puts 'Shutting down...'
  interrupted = true
end

# Setup LEDs
pins = SMSService::LEDHandler.new([LED1, LED2, LED3])
# End Setup LEDs

# Start setup: Flash indicator
pins.flash

# Setup serialport
sim = SMSService::SIMHandler.new(Serial.new(SERIAL_PORT, SERIAL_BAUD_RATE))
# End Setup serialport

# Set to text mode
raise 'SIM: Text mode could not be activated' unless sim.set_text_mode
puts 'Text mode activated...'
# End Set to text mode

# Setup complete: Stop flash indicator
pins.stop_flash
puts 'Setup complete...'

# Setup Redis
host = ENV['REDIS_HOST']
port = ENV['REDIS_PORT']
password = ENV['REDIS_PASSWORD']
redis = SMSService::RedisHandler(Redis.new(host: host, port: port,
                                           password: password))

redis.set('mykey', 'hello world')
