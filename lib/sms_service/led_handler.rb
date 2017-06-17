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

    # rubocop:disable Metrics/MethodLength
    def flash(time = 0.500)
      stop_flash unless @flash.nil?
      @flash = Thread.new do
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

    def stop_flash
      return if @flash.nil?
      @flash.exit
      @pins.each do |_i, p|
        p.off
      end
    end

    def ascending(time = 0.250)
      stop_ascending unless @ascending.nil?
      @ascending = Thread.new do
        loop do
          @pins.each do |_i, p|
            p.on
            sleep time
          end
          @pins.reverse_each do |_i, p|
            p.off
            sleep time
          end
        end
      end
    end

    def stop_ascending
      return if @ascending.nil?
      @ascending.exit
      @pins.each do |_i, p|
        p.off
      end
    end

    def lightshow(time = 0.500)
      stop_lightshow unless @lightshow.nil?
      @lightshow = Thread.new do
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

    def stop_lightshow
      return if @lightshow.nil?
      @lightshow.exit
      @pins.each do |_i, p|
        p.off
      end
    end
  end
end
