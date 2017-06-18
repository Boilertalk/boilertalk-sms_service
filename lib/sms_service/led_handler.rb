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

      @animations = {}
    end

    def pin(p)
      @pins[p]
    end

    # rubocop:disable Metrics/MethodLength
    def flash(time = 0.500)
      stop_animations
      @animations[:flash] = Thread.new do
        loop do
          @pins.each do |_i, p|
            p.on
          end
          sleep time
          @pins.each do |_i, p|
            p.off
          end
        end
      end
    end

    def ascending(time = 0.250)
      stop_animations
      @animations[:ascending] = Thread.new do
        loop do
          @pins.each do |_i, p|
            p.on
            sleep time
          end
          @pins.each do |_i, p|
            p.off
            sleep time
          end
        end
      end
    end

    def lightshow(time = 0.500)
      stop_animations
      @animations[:lightshow] = Thread.new do
        @pins.each do |_i, p|
          p.off
        end
        loop do
          @pins.each do |_i, p|
            p.on
            sleep time
            p.off
          end
        end
      end
    end

    def stop_animations
      @animations.each do |_k, v|
        v.exit
      end

      @animations = {}
    end
  end
end
