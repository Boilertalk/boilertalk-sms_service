require 'json'

module SMSService
  # A redis handler specifically for this project
  class RedisHandler
    attr_reader :redis, :key

    def initialize(redis, key)
      @redis = redis
      @key = key
    end

    def dequeue
      d = @redis.rpop(@key)
      return nil if d.nil?
      parse_json(d)
    end

    private

    def parse_json(json)
      j = JSON.parse(json)
      return j
    rescue JSON::ParserError
      return nil
    end
  end
end
