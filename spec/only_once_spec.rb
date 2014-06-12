require "only_once"

describe Only do
  before(:each) do
    Only.reset_all
  end

  it "passes block result through" do
    result = Only.once(:key) do
      :result
    end
    expect(result).to eq(:result)
  end

  it "does not run block if lock key is set" do
    Only.once(:key) do :result end
    expect { |b|
      Only.once(:key, &b)
    }.not_to yield_control
  end

  it "returns block result even if lock key set" do
    Only.once(:key) do :data end
    result = Only.once(:key) do
      :data
    end
    expect(result).to eq(:data)
  end

  it "preserves symbols in hashes" do
    input = { a: 1 }

    Only.once(:key) do input end
    result = Only.once(:key) do
      input
    end
    expect(result).to eq(input)
  end

  it "returns the first block result" do
    Only.once(:key) do :first end
    result = Only.once(:key) do
      :second
    end
    expect(result).to eq(:first)
  end

  describe "Redis Fail" do
    it "gracefully handles when redis connection failure" do
      bad_redis = Redis.new(url: "redis://127.0.0.1:32342/1")
      expect(Only).to receive(:redis).at_least(1).times.and_return bad_redis

      result = Only.once(:key) do
        :result
      end
      expect(result).to eq(:result)

      result = Only.once(:key) do
        :result_2
      end
      expect(result).to eq(:result_2)
    end

    it "gracefully handles an improperly formatted redis-url"  do
      expect(Only).to receive(:redis).at_least(1).times {
        Redis.new(url: "bad-redis")
      }

      result = Only.once(:key) do
        :result
      end
      expect(result).to eq(:result)

      result = Only.once(:key) do
        :result_2
      end
      expect(result).to eq(:result_2)
    end

    it "gracefully handles an invalid redis-url"  do
      bad_redis = Redis.new(url: "http://127.0.0.1:3")
      expect(Only).to receive(:redis).at_least(1).times.and_return bad_redis

      result = Only.once(:key) do
        :result
      end
      expect(result).to eq(:result)

      result = Only.once(:key) do
        :result_2
      end
      expect(result).to eq(:result_2)
    end
  end
end
