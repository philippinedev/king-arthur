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

    def find_by_name(name)
      @@database.filter { |row| row.name == name }
        .first
    end

    def reseed
      @@database = []
      Seed.call
    end

    def transformers
      [
        GetRelationshipTransformer,
        AddChildTransformer
      ]
    end
  end

  def initialize
    @@database = []
  end
end

