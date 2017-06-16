module SMSService
  # A redis handler specifically for this project
  class RedisHandler
    attr_reader :redis

    def initialize(redis)
      @redis = redis
    end
  end
end
