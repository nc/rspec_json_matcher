require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe JSON::Matcher do
  before do
    @matcher = JSON::Matcher
  end
  
  # 
  # JSON::Matcher.new.match(actual, expected)
  #
  
  describe "exact match" do
    it "should match if equal" do
      h1 = { :a => :b }
      h2 = { :a => :b }

      @matcher.match(h1, h2).should be_true
    end

    it "should not match if not equal" do
      h1 = { :a => :b }
      h2 = { :a => :c }

      @matcher.match(h1, h2).should_not be_true
    end 
  end
  
  describe "class match" do
    it "should match if the keys match and the values are the class of the actual values" do
      h1 = { :a => "this is a String" }
      h2 = { :a => String }

      @matcher.match(h1, h2).should be_true
    end

    it "should not match if the keys match and the values are not the class of the actual values" do
      h1 = { :a => "this is a String" }
      h2 = { :a => Fixnum }

      @matcher.match(h1, h2).should_not be_true
    end
  end

  describe "hash match" do
    it "should match if inner hashes match" do
      h1 = { :a => { :b => "dude" } }
      h2 = { :a => { :b => String } }

      @matcher.match(h1, h2).should be_true
    end

    it "should not match if inner hashes don't match" do
      h1 = { :a => { :b => "dude" } }
      h2 = { :a => { :c => String } }

      @matcher.match(h1, h2).should_not be_true
    end
  end
  
  describe "array match" do
    it "should match if inner arrays match" do
      h1 = { :b => [] }
      h2 = { :b => [] }

      @matcher.match(h1, h2).should be_true
    end

    it "should not match if inner arrays don't match" do
      h1 = { :b => [] }
      h2 = { :b => [:gaaa] }

      @matcher.match(h1, h2).should_not be_true
    end
  end
  
  describe "api_json_format match" do
    class Place
      def self.api_json_format
        {
          "place" => {
            "name" => String
          }
        }
      end
    end

    it "should match if Place.api_json_format matches" do

      h1 = { :a => { "place" => { "name" => "busaba" } } }
      h2 = { :a => Place }

      @matcher.match(h1, h2).should be_true    
    end
    
    it "should not match if Place.api_json_format does not match" do
      
      h1 = { :a => { "place" => { "fun_times" => true } } }
      h2 = { :a => Place }
      
      @matcher.match(h1, h2).should be_false
    end
  end
  
  describe "api_json_format array match" do
    class Place
      def self.api_json_format
        {
          "place" => {
            "name" => String
          }
        }
      end
    end
    
    class City
      def self.api_json_format
        {
          "city" => {
            "name" => String,
            "places" => JSON.Array(Place)
          }
        }
      end
    end
    
    it "should match if City.api_json_format matches" do
      h1 = { :a => { "city" => { "name" => "London", "places" => [{ "place" => { "name" => "Busaba" }}, { "place" => { "name" => "Ping Pong" } }] } } }
      h2 = { :a => City }
      
      @matcher.match(h1, h2).should be_true
    end
    
    it "should not match if City.api_json_format doesn't match" do
      h1 = { :a => { "city" => { "name" => "London", "places" => [{ "place" => { "name" => "Busaba", "wrong" => "should not be here" }}, { "place" => { "name" => "Ping Pong" } }] } } }
      h2 = { :a => City }
      
      @matcher.match(h1, h2).should be_false
    end
  end
  
  describe "optional match" do
    it "should match if optional item is present" do
      h1 = { :a => "This is a string" }
      h2 = { :a => JSON.Optional(String) }
      
      @matcher.match(h1, h2).should be_true      
    end
    
    it "should match if optional item is not present" do
      h1 = { :b => "This is a string" }
      h2 = { :a => JSON.Optional(String), :b => String }
      
      @matcher.match(h1, h2).should be_true
    end
    
  end

end
