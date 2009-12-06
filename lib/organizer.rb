require File.expand_path(File.dirname(__FILE__) + "/core_ext/string")
require File.expand_path(File.dirname(__FILE__) + "/rules")

module Organizer
  class Organizer
    
    class ContainerNotDefined < Exception; end
    
    attr_reader :rules_file
    attr_reader :container_path
    
    def initialize(rules=nil)
      @rules_file = File.expand_path(File.dirname(__FILE__) + "/rules.yml") if rules.nil?
      
      rules_data = File.open(@rules) {|r| YAML.load(r)}
      
      @container_path = rules_data["container_path"]
      raise ContainerNotDefined if @container_path.nil?
      
      @rules = Organizer::Rules.load(rules_data)
    end
    
    
  end
end