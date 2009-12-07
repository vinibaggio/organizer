#!/usr/bin/ruby

# The organizer
# Organize files by moving them to ther proper places by
# obeying a rules file (using regular expressions).

# I was tired of repeating myself.

# Author: Vinicius Baggio Fuentes
#         vinibaggio@gmail.com

# Copyright (c) 2009 Vinicius B. Fuentes http://me.vinibaggio.com,
# released under the MIT license
require 'rubygems'
require 'choice'

# require File.expand_path(File.dirname(__FILE__) + "/../lib/organizer")

class Organizer
  class << self
    def init
      Choice.options do
        header ''
        header 'Options:'
        
        option :dryrun do
          short '-d'
          long '--dryrun'
          desc 'Run the program normally but does not make any changes effective. Useful for testing.'
        end
        
        option :rules do
          short '-r'
          long '--rules=RULES'
          desc 'Specify the rules files for the program to read from.'
        end
      end
    end
  end
end

Organizer.init
p Choice.choices.rules

#         @rules_file = File.expand_path(File.dirname(__FILE__) + "/rules.yml")