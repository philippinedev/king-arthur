class Person < Repository
  MALE   = 'Male'.freeze
  FEMALE = 'Female'.freeze

  GENDERS = [ MALE, FEMALE ]

  attr_accessor :id, :name, :gender, :father, :mother, :spouse

  def attributes
    {
      id: id,
      name: name,
      gender: gender,
      father: {
        id: father&.id,
        name: father&.name
      },
      mother: {
        id: mother&.id,
        name: mother&.name
      },
      spouse: {
        id: spouse&.id,
        name: spouse&.name
      }
    }
  end

  # class << self
  #   def new(params)
  #     super(params)
  #   end
  # end

  def initialize(name:, gender:, father: nil, mother: nil, spouse: nil)
    @name = name
    @gender = gender
    @father = father
    @mother = mother
    @spouse = spouse
  end

  def after_save
    spouse.spouse = self if spouse
    super
  end

  def valid?
    valid_gender? \
      && valid_name? \
      && valid_father? \
      && valid_mother? \
      && valid_spouse?
  end

  def relatives_with_relation(relation)
    return sons           if relation == 'Son'
    return daughters      if relation == 'Daughter'
  #
  #   return paternal_uncle if relation == 'Paternal-Uncle' # TODO
  #   return maternal_uncle if relation == 'Maternal-Uncle' # TODO
  #   return paternal_aunt  if relation == 'Paternal-Aunt'  # TODO
  #   return maternal_aunt  if relation == 'Maternal-Aunt'

  #   return sister_in_law  if relation == 'Sister-In-Law'
  #   return brother_in_law if relation == 'Brother-In-Law' # TODO
  #   return siblings       if relation == 'Siblings'
  end

  def sons
    if gender == MALE
      Person.where(father_id: self.id, gender: MALE)
    else
      Person.where(mother_id: self.id, gender: MALE)
    end
  end

  def daughters
    if gender == MALE
      Person.where(father_id: self.id, gender: FEMALE)
    else
      Person.where(mother_id: self.id, gender: FEMALE)
    end
  end

  # def siblings
  #   mother.children
  #     .filter { |child| child.name != self.name }
  # end

  # def sister_in_law
  #   male_siblings.map { |brother| brother.spouse }.compact
  # end

  # def maternal_aunt
  #   mother.female_siblings
  # end

  # def female_siblings
  #   mother.female_children
  #     .filter { |child| child.name != self.name }
  # end

  # def male_siblings
  #   mother.male_children
  #     .filter { |child| child.name != self.name }
  # end

  # def children
  #   Application.database
  #     .filter { |child| child.mother&.name == self.name }
  # end

  # def female_children
  #   children
  #     .filter { |child| child.gender == FEMALE }
  # end

  # def male_children
  #   children
  #     .filter { |child| child.gender == MALE }
  # end

  # def male?
  #   gender == MALE
  # end

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
