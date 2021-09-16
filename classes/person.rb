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

    return siblings       if relation == 'Siblings'
    return sisters_in_law  if relation == 'Sister-In-Law'
    return brothers_in_law if relation == 'Brother-In-Law'

    return paternal_uncles if relation == 'Paternal-Uncle'
    return maternal_uncles if relation == 'Maternal-Uncle'
    return paternal_aunts  if relation == 'Paternal-Aunt'
    return maternal_aunts  if relation == 'Maternal-Aunt'
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

  def siblings
    mother&.mothers_children
      &.filter { |child| child.id != self.id } || []
  end

  def brothers
    siblings
      .filter { |child| child.gender == MALE }
  end

  def sisters
    siblings
      .filter { |child| child.gender == FEMALE }
  end

  def sisters_in_law
    (sisters_in_law_via_spouse + sisters_in_law_via_siblings)
  end

  def brothers_in_law
    (brothers_in_law_via_spouse + brothers_in_law_via_siblings)
  end

  def paternal_uncles
    father.brothers
  end

  def maternal_uncles
    mother.brothers
  end

  def paternal_aunts
    father.sisters
  end

  def maternal_aunts
    mother.sisters
  end

  def sisters_in_law_via_spouse
    spouse&.sisters || []
  end

  def sisters_in_law_via_siblings
    brothers.map { |bro| bro.spouse }
      .compact
  end

  def brothers_in_law_via_spouse
    spouse&.brothers || []
  end

  def brothers_in_law_via_siblings
    sisters.map { |sis| sis.spouse }
      .compact
  end

  def mothers_children
    Person.where(mother_id: self.id)
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
