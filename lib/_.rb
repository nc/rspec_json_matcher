module JSON
  class 
    
  end
  
  class Matcher

    def match(actual, expected)

      if expected.respond_to?(:api_json_format)
        match(actual, expected.api_json_format)     

      elsif expected.is_a?(Class)
        actual.class == expected

      elsif actual.is_a?(Hash) and expected.is_a?(Hash)
        return false unless actual.keys.size == expected.keys.size
        return !actual.keys.map { |k| match(actual[k], expected[k]) }.flatten.include?(false)

      elsif actual.is_a?(Array) and expected.is_a?(Array)
        actual.size == expected.size and actual.zip(expected).map { |pair| match(pair.first, pair.last) }

      else
        actual == expected
      end
    end

  end
end