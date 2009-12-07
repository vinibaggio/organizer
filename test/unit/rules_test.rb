require File.expand_path(File.dirname(__FILE__) + "/../test_helper")

require "rules"
include Organizer

class TestRules < Test::Unit::TestCase
  
  def test_tell_if_data_is_invalid
    invalid_data = <<DATA
invalid_data:
  invalid_info
DATA
    assert_invalid_data(invalid_data)
  end
  
  def test_tell_if_single_entry_is_valid
    data = <<DATA
rules:
  my_files:
    pattern: \w
    folder: ~/
DATA
    assert_valid_data(data)
  end
  
  def test_tell_if_multiple_entries_are_valid
    data = <<DATA
rules:
  my_pictures:
    pattern: \w*\.jpg
    folder: ~/Pictures
  my_files:
    pattern: \w
    folder: ~/
  
DATA
    assert_valid_data(data)
  end
  
  def test_if_ignores_alien_data
    data = <<DATA
some_path: ~/Container
rules:
  my_pictures:
    pattern: \w*\.jpg
    folder: ~/Pictures
  my_files:
    pattern: \w
    folder: ~/

DATA
    assert_valid_data(data)
  end
  
  def test_if_rules_iterate_all_rules
    rules = create_valid_rules
    rules.each do |rule|
      assert(["my_pictures", "my_trip", "my_series"].include?(rule[0]))
      ["pattern", "folder"].each {|v| assert(rule[1].keys.include?(v)) }
    end
  end
  
  def test_if_matches_once
    rules = create_valid_rules
    assert_equal ["my_pictures", "~/Pictures"], rules.match("File.jpg")
  end
  
  def test_if_matches_multiple_times
    rules = create_valid_rules
    assert_equal [["my_pictures", "~/Pictures"], ["my_trip", "~/Pictures/My Trip"]], rules.match("Trip to Alaska.jpg")
  end
  
  def test_if_matchs_substitute
    rules = create_valid_rules
    assert_equal ["my_series", "~/Lost/Season 01/"], rules.match("Lost.s01e01.Bla.avi")
    assert_equal ["my_series", "~/Prison Break/Season 02/"], rules.match("Prison Break.s02e01.Bla.avi")
  end
  
  def test_if_matches_valid_path
    rules = create_valid_rules
  end
  
  private
  def assert_valid_data(data)
    assert Rules.valid?(YAML.load(data))
  end
  
  def assert_invalid_data(data)
    assert !Rules.valid?(YAML.load(data))
  end
  
  def create_valid_rules
    data = <<DATA
rules:
  my_pictures:
    pattern: (\\w*)\\.jpg
    folder: ~/Pictures
  my_trip:
    pattern: Trip.*jpg
    folder: ~/Pictures/My Trip
  my_series:
    pattern: ^([\\w\\s]*)\\.s(\\d{2}).*\\.avi$
    folder: ~/$1/Season $2/

DATA
    Rules.load(YAML.load(data))
  end
end