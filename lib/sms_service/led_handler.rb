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

    def lightshow
      @lightshow = Thread.new do
        @pins.each(&:off)
        loop do
          @pins.each do |p|
            p.on
            sleep 100
            p.off
          end
        end
      end
    end

    def stop_lightshow
      return if @lightshow.nil?
      @lightshow.exit
      @pins.each(&:off)
    end
  end
end