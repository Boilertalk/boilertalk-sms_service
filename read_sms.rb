require_relative 'lib/sms_service'

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

# Delete all sms
serialport.write "AT+CMGDA=\"DEL ALL\"\r"
sleep 1
puts 'All sms deleted...'
# End Delete all sms

reply = serialport.get_all # Clean buf
puts 'Listening for incoming SMS...'
loop do
  # Exit if interrupted
  exit if interrupted

  reply = serialport.get_all
  next unless reply != ''

  serialport.write "AT+CMGR=1\r"
  sleep 1
  reply = serialport.get_all
  puts 'SMS received. Content:'
  puts reply

  if reply.upcase.include? 'ON'
    if reply.upcase.include? 'LED1'
      puts 'LED 1 ON'
      led1.on
    elsif reply.upcase.include? 'LED2'
      puts 'LED 2 ON'
      led2.on
    elsif reply.upcase.include? 'LED3'
      puts 'LED 3 ON'
      led3.on
    elsif reply.upcase.include? 'ALL'
      puts 'ALL LED ON'
      led1.on
      led2.on
      led3.on
    end
  elsif reply.upcase.include? 'OFF'
    if reply.upcase.include? 'LED1'
      puts 'LED 1 OFF'
      led1.off
    elsif reply.upcase.include? 'LED2'
      puts 'LED 2 OFF'
      led2.off
    elsif reply.upcase.include? 'LED3'
      puts 'LED 3 OFF'
      led3.off
    elsif reply.upcase.include? 'ALL'
      puts 'ALL LED OFF'
      led1.off
      led2.off
      led3.off
    end
  end

  sleep 0.500
  serialport.write "AT+CMGDA=\"DEL ALL\"\r" # delete all
  sleep 0.500
  serialport.get_all # Clear buffer
  sleep 0.500
end
