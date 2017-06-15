module RubyserialExtensions
  module Serial
    # Convenient ways to get all the output of the serial
    module GetAll
      def get_all(batch_size = 100)
        output = ''

        current = read(batch_size)
        while current != ''
          output += current
          current = read(batch_size)
        end

        output
      end
    end
  end
end
