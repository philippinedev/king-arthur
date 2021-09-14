require 'pry'

class FileReader
  class << self
    def call(file)
      new(file).readlines
    end
  end

  def initialize(file)
    @file = file
  end

  def readlines
    raw_lines
      .map { |line| line.strip }
      .compact
  end

  private

  def raw_lines
    File.readlines(file_path)
  end

  def file_path
    "#{File.dirname(__FILE__)}/../../test_files/#{@file}"
  end
end
