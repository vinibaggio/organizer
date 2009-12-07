require File.expand_path(File.dirname(__FILE__) + "/../test_helper")

require "organizer"
include Organizer

class TestOrganizer < Test::Unit::TestCase
  def test_set_default_values_for_roles_file_and_container_folder
    rules_data = <<-DATA
container_path: ~/Container
    DATA
    
    @organizer = Organizer::Organizer.new(rules_data)
    assert_equal(File.expand_path("~/Container"), @organizer.container_path)
  end
end