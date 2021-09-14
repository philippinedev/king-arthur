class Person
  MALE   = 'Male'.freeze
  FEMALE = 'Female'.freeze

  GENDERS = [ MALE, FEMALE ]

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
    spouse.spouse = self if spouse
    self
  end

  def valid?
    valid_gender? \
      && valid_name? \
      && valid_father? \
      && valid_mother? \
      && valid_spouse?
  end

  def relatives_with_relation(relation)
    return paternal_uncle if relation == 'Paternal-Uncle' # TODO
    return maternal_uncle if relation == 'Maternal-Uncle' # TODO
    return paternal_aunt  if relation == 'Paternal-Aunt'  # TODO
    return maternal_aunt  if relation == 'Maternal-Aunt'

    return sister_in_law  if relation == 'Sister-In-Law'
    return brother_in_law if relation == 'Brother-In-Law' # TODO
    return siblings       if relation == 'Siblings'

    return son            if relation == 'Son'            # TODO
    return daughter       if relation == 'Daughter'       # TODO
  end

  def siblings
    mother.children
      .filter { |child| child.name != self.name }
  end

  def sister_in_law
    male_siblings.map { |brother| brother.spouse }.compact
  end

  def maternal_aunt
    mother.female_siblings
  end

  def female_siblings
    mother.female_children
      .filter { |child| child.name != self.name }
  end

  def male_siblings
    mother.male_children
      .filter { |child| child.name != self.name }
  end

  def children
    Application.database
      .filter { |child| child.mother&.name == self.name }
  end

  def female_children
    children
      .filter { |child| child.gender == FEMALE }
  end

  def male_children
    children
      .filter { |child| child.gender == MALE }
  end

  def male?
    gender == MALE
  end

  private

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
