#!/usr/bin/env ruby

require 'pry'

Dir["./classes/*.rb"].each { |file| require file }
Dir["./classes/command/*.rb"].each { |file| require file }
Dir["./data/*.rb"].each { |file| require file }

def main
  unless ARGV.count == 1
    return "ERROR: Can only process one file at a time."
  end

  file = ARGV[0]

  unless File.exist? file
    return "ERROR: File does not exist."
  end

  Application.start!

  file_path = "#{File.dirname(__FILE__)}/#{file}"
  FileProcessor.call(file_path)
end

puts main

