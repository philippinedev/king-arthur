class Person
  GENDERS = [
    'Male',
    'Female'
  ]

  attr_accessor :name, :gender, :father, :mother, :spouse

  class << self
    def create(params)
      new(params).save
    end
  end

  def initialize(name:, gender:, father: nil, mother: nil, spouse: nil)
    @name = name
    @gender = gender
    @father = father
    @mother = mother
    @spouse = spouse
  end

  def save
    Application.push(self)
    self
  end

  def valid?
    valid_gender? \
      && valid_name? \
      && valid_father? \
      && valid_mother? \
      && valid_spouse?
  end

  def valid_gender?
    GENDERS.include? @gender
  end

  def valid_name?
    !name.nil? && name != ''
  end

  def valid_father?
    father.nil? || father.class == Person
  end

  def valid_mother?
    mother.nil? || mother.class == Person
  end

  def valid_spouse?
    spouse.nil? || spouse.class == Person
  end
end

