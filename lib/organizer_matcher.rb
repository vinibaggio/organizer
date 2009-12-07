require File.expand_path(File.dirname(__FILE__) + "/rules")

module Organizer
  
  class ContainerNotDefinedError < Exception; end
  class InvalidDataError < Exception; end
  
  class OrganizerMatcher
    
    attr_reader :container_path
    
    def initialize(raw_data)
      rules_data = YAML.load(raw_data)
      
      raise InvalidDataError if raw_data.nil? or raw_data.empty?
      
      raise ContainerNotDefinedError if rules_data["container_path"].nil?
      @container_path = File.expand_path(rules_data["container_path"])
      
      
      @rules = Organizer::Rules.load(rules_data)
      @container_files = Dir.glob("#{@container_path}/*").sort
    end
    
    def each_match
      @container_files.each do |file|
        matches = @rules.match(file)
        yield [file] + matches unless matches.nil?
      end
    end
    
    
  end
end