class Application
  class << self
    def start!
      new
      Seed.call
    end

    def database
      @@database
    end

    def push(person)
      @@database << person
    end
  end

  def initialize
    @@database = []
  end
end

