module SMSService
  # A SIM handler specialized for the SIM800l module
  class SIMHandler
    attr_reader :serialport

    def initialize(serialport)
      @serialport = serialport
    end

    def set_text_mode
      @serialport.write "AT+CMGF=1\r"
      sleep 0.5
      reply = @serialport.get_all

      # Return true if reply contains OK
      reply.upcase.include? 'OK'
    end

    def send_sms(number, text)
      @serialport.write "AT+CMGS=\"#{number}\"\r"
      sleep 1
      @serialport.write text
      sleep 1
      @serialport.write "\x1A"
      sleep 1
      reply = @serialport.get_all

      puts reply

      # Return true if reply contains OK
      reply.upcase.include? 'OK'
    end
  end
end
