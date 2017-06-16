require 'rubygems'
require 'bundler'
Bundler.require(:default)

# Monkeypatch Serial
require_relative 'lib/rubyserial_extensions/serial/get_all'
Serial.include RubyserialExtensions::Serial::GetAll
# End Monkeypatch Serial

require_relative 'sms_service/led_handler'
require_relative 'sms_service/redis_handler'
require_relative 'sms_service/sim_handler'
