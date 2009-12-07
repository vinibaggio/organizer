require File.expand_path(File.dirname(__FILE__) + "/core_ext/string")
require File.expand_path(File.dirname(__FILE__) + "/rules")

module Organizer
  
  class ContainerNotDefined < Exception; end
  
  class Organizer
    
    attr_reader :container_path
    
    def initialize(raw_data)
      rules_data = YAML.load(raw_data)
      
      @container_path = File.expand_path(rules_data["container_path"])
      raise ContainerNotDefined if @container_path.nil?
      
      @rules = Organizer::Rules.load(rules_data)
      @container_files = Dir.glob("#{@container_path}/*")
    end
    
    def method_name
      
    end
    
    
  end
end