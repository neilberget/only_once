require "only_once/version"
require "yaml"
require "redis"

module Only
  TIMEOUT = 30

  def self.redis
    redis ||= ::Redis.new
  end

  def self.reset_all
    redis.keys("only::*").each { |key|
      redis.del key
    }
  end

  # Public
  # Ensures the passed in block is only called once no matter how many times
  # once is called with the associated key
  #
  # When you call once a second time, it will block, wait for the first
  # invocation to finish, and return the first invocation's response
  #
  # Returns: what the provided block returns
  def self.once(key)
    unless locked?(key)
      response = yield

      store(key, response)
    else
      response = retrieve(key)
    end

    response
  rescue Redis::CannotConnectError, ArgumentError
    yield # Fallback to block if Redis not available
  end

  def self.locked?(key)
    locked = redis.getset(redis_lock_key(key), 1) == "1"
    redis.expire redis_lock_key(key), TIMEOUT
    locked
  end

  def self.redis_lock_key(lock_key)
    "only::lock::#{lock_key}"
  end

  def self.store(key, response)
    redis.lpush  redis_data_key(key), YAML::dump(response)
    redis.expire redis_data_key(key), TIMEOUT
  end

  # Retrieve data from redis. Waiting if necessary if data is not yet ready.
  def self.retrieve(key)
    data_key = redis_data_key(key)
    response = redis.brpoplpush data_key, data_key, TIMEOUT
    YAML::load(response)
  end

  def self.redis_data_key(key)
    "only::data::#{key}"
  end
end
