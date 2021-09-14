class GetRelationshipTransformer
  COMMAND = 'GET_RELATIONSHIP'.freeze

  PARAMS_COUNT = 3

  RELATIONSHIPS = [
    'Paternal-Uncle',
    'Maternal-Uncle',
    'Paternal-Aunt',
    'Maternal-Aunt',
    'Sister-In-Law',
    'Brother-In-Law',
    'Son',
    'Daughter',
    'Siblings'
  ].freeze

  class << self
    def call(row_input)
      new(row_input).call
    end
  end

  def initialize(row_input)
    @row_input = row_input
  end

  def call
    return unless valid?(:get_relationship)

    {
      command: command,
      person: person,
      relationship: relationship
    }
  end

  private

  def valid?(key)
    return false if @row_input.nil?
    return false unless RELATIONSHIPS.include? relationship

    COMMAND == command && PARAMS_COUNT == raw_columns.count
  end

  def command
    @command ||= raw_columns[0]
  end

  def person
    raw_columns[1]
  end

  def relationship
    raw_columns[2]
  end

  def raw_columns
    @raw_columns ||= @row_input.split(' ')
      .map { |item| item.strip }
      .compact
  end
end
