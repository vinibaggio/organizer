require File.expand_path(File.dirname(__FILE__) + "/core_ext/string")
require File.expand_path(File.dirname(__FILE__) + "/rules")

module Organizer
  
  class ContainerNotDefined < Exception; end
  
  class OrganizerMatcher
    
    attr_reader :container_path
    
    def initialize(raw_data)
      rules_data = YAML.load(raw_data)
      
      @container_path = File.expand_path(rules_data["container_path"])
      raise ContainerNotDefined if @container_path.nil?
      
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