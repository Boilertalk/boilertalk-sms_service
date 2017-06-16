require 'pi_piper'

module SMSService
  # A LED handler
  class LEDHandler
    def initialize(pins)
      unless pins.respond_to? 'each'
        raise ArgumentError, 'pins must be an array'
      end

      @pins = {}
      pins.each do |p|
        pin = PiPiper::Pin.new(pin: p, direction: :out)
        @pins[p] = pin
      end
    end

    def pin(p)
      @pins[p]
    end
  end
end
