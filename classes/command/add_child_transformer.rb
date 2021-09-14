class AddChildTransformer
  COMMAND = 'ADD_CHILD'.freeze

  PARAMS_COUNT = 4

  GENDERS = {
    male: 'Male',
    female: 'Female'
  }.freeze

  class << self
    def call(row_input)
      new(row_input).call
    end
  end

  def initialize(row_input)
    @row_input = row_input
  end

  def call
    return unless valid?(:add_child)

    {
      command: command,
      mother: mother,
      child: child,
      male: male?
    }
  end

  private

  def valid?(key)
    return false if @row_input.nil?
    return false unless GENDERS.values.include? gender

    COMMAND == command && PARAMS_COUNT == raw_columns.count
  end

  def command
    @command ||= raw_columns[0]
  end

  def mother
    raw_columns[1]
  end

  def child
    raw_columns[2]
  end

  def gender
    raw_columns[3]
  end

  def male?
    gender == GENDERS[:male]
  end

  def raw_columns
    @raw_columns ||= @row_input.split(' ')
      .map { |item| item.strip }
      .compact
  end
end
