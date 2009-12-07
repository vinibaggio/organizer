require "yaml"

module Organizer
  
  class Rules
    
    def initialize(data)
      @rules = data["rules"]
    end
    
    include Enumerable
    def each
      @rules.each{|rule| yield rule}
    end
    
    def match(file)
      matches = nil
      each do |rule|
        # [0] = name, [1] = {pattern: bla, folder: bla}
        # puts "Testing #{rule[0]}"
        match = perform_match(file, rule[1])
        unless match.nil?
          matches ||= []
          matches << [rule[0], match]
        end
      end
      matches.flatten! if matches.size == 1
      matches
    end
    
    private
    def perform_match(to_be_matched, rule)
      pattern = rule["pattern"].dup
      folder = rule["folder"].dup
      
      match_data = Regexp.new(pattern).match(to_be_matched)
      unless match_data.nil?
        # replace "named" matches
        for i in 1...match_data.size
          folder.gsub!("$#{i}", match_data[i])
        end
        folder
      else
        nil
      end
    end


    # Class methods
    class << self
      def load(data=nil)
      
        if valid?(data)
          Rules.new(data)
        else
          nil
        end
      
      end
      
      def valid?(data)
        
        return false if data.nil?
        return false if data["rules"].nil?
        
        for name, rules in data["rules"]
          return false if rules["pattern"].nil?
          return false if rules["folder"].nil?
        end
        
        true
      end
      
    end
  
  end
end