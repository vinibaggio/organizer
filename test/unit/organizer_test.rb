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
  
  def test_files_single_match
    rules_data = <<DATA
container_path: ./container
rules:
  my_texts:
    pattern: .*txt
    folder: ~/Texts

DATA
  
    @organizer = Organizer::Organizer.new(rules_data)
    @organizer.each_match do |match|
      assert_equal File.expand_path("./container") + "/file1.txt", match[0]
      assert_equal ["my_texts", "~/Texts"], match[1]
    end
  end

  def test_files_multiple_matches
    rules_data = <<DATA
container_path: ./container
rules:
  my_texts:
    pattern: .*txt
    folder: ~/Texts
  my_files:
    pattern: file(\\d).*txt
    folder: ~/Files

DATA

    @organizer = Organizer::Organizer.new(rules_data)
    @organizer.each_match do |match|
      assert_equal File.expand_path("./container") + "/file1.txt", match[0]
      assert match.include?(["my_texts", "~/Texts"])
      assert match.include?(["my_files", "~/Files"])
    end
  end
  
end