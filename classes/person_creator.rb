class PersonCreator
  class << self
    def call(params)
      new(params).call
    end
  end

  def initialize(name:, gender:, father:, mother:, spouse:)
    @name = name
    @gender = gender
    @father = father
    @mother = mother
    @spouse = spouse
  end

  def call
    person = Person.new(
      name: @name,
      gender: @gender,
      father: @father,
      mother: @mother,
      spouse: @spouse
    )

    person.save if person.valid?
  end
end

