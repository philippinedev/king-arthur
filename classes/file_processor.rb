class FileProcessor
  ADD_CHILD        = 'ADD_CHILD'.freeze
  GET_RELATIONSHIP = 'GET_RELATIONSHIP'.freeze

  MALE   = 'Male'.freeze
  FEMALE = 'Female'.freeze

  class << self
    def call(file)
      new(file).call
    end
  end

  def initialize(file)
    @file = file
  end

  def call
    command_rows.map { |row| process(row) }
  end

  def process(row)
    return add_child(row)        if row[:command] == ADD_CHILD
    return get_relationship(row) if row[:command] == GET_RELATIONSHIP
  end

  def add_child(row)
    mother = Person.where(name: row[:mother]).first
    return 'PERSON_NOT_FOUND' if mother.nil?
    return 'CHILD_ADDITION_FAILED' if mother.male?

    father = mother.spouse

    params = {
      name: row[:child],
      gender: row[:male] ? MALE : FEMALE,
      father: father,
      mother: mother
    }

    PersonCreator.call(params)
    'CHILD_ADDED'
  end

  def get_relationship(row)
    person = Person.where(name: row[:person]).first
    return 'PERSON_NOT_FOUND' if person.nil?

    relatives = person.relatives_with_relation(row[:relationship])
    relatives = relatives.map { |relative| relative.name }

    if relatives.any?
      relatives.sort.join(' ')
    else
      'NONE'
    end
  end

  def command_rows
    FileReader.call(@file).map { |row|
      Application.transformers.map { |t| t.call(row) }
        .compact
        .first
    }.compact
  end
end

