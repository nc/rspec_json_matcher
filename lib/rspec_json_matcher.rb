module JSON
  
  def self.Array(klass)
    ArrayOf.new(klass)
  end
  
  class ArrayOf
    attr_reader :klass
    
    def initialize(klass)
      @klass = klass
    end
  end
  
  def self.Optional(klass)
    Optional.new(klass)
  end
  
  class Optional
    attr_reader :klass
    
    def initialize(klass)
      @klass = klass
    end
  end
  
  class Matcher

    def self.match(actual, expected)

      if expected.respond_to?(:api_json_format)
        match(actual, expected.api_json_format)
        
      elsif expected.is_a?(Optional)
        actual.class == expected.klass or actual.nil?

      elsif expected.is_a?(Class)
        actual.class == expected

      elsif actual.is_a?(Hash) and expected.is_a?(Hash)
        return !actual.keys.map { |k| match(actual[k], expected[k]) }.flatten.include?(false)

      elsif actual.is_a?(Array) and expected.is_a?(ArrayOf)
        !actual.map { |o| match(o, expected.klass.api_json_format) }.include?(false)

      elsif actual.is_a?(Array) and expected.is_a?(Array)
        actual.size == expected.size and actual.zip(expected).map { |pair| match(pair.first, pair.last) }

      else
        actual == expected
      end
    end

  end
end