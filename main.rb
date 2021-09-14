#!/usr/bin/env ruby

require 'pry'

Dir["./classes/*.rb"].each { |file| require file }
Dir["./classes/command/*.rb"].each { |file| require file }

def main
  unless ARGV.count == 1
    return "ERROR: Can only process one file at a time."
  end

  file_path = ARGV[0]

  unless File.exist? file_path
    return "ERROR: File does not exist."
  end

  Processor.call(file_path)
end

puts main

