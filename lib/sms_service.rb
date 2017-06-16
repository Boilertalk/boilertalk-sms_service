require 'rubygems'
require 'bundler'
Bundler.require(:default)

# Load dotenv variables
Dotenv.load

# Monkeypatch Serial
require_relative 'rubyserial_extensions/serial/get_all'
Serial.include RubyserialExtensions::Serial::GetAll
# End Monkeypatch Serial

require_relative 'sms_service/led_handler'
require_relative 'sms_service/redis_handler'
require_relative 'sms_service/sim_handler'
