class Seed
  class << self
    def call
      male   = 'Mail'
      female = 'Femail'

      # First Generation
      king_arthur    = Person.create(name: 'King Arthur', gender: male)
      queen_margaret = Person.create(name: 'Queen Margaret', gender: female)

      # Second Generation
      bill           = Person.create(name: 'Bill', gender: male, father: king_arthur, mother: queen_margaret)
      _              = Person.create(name: 'Charlie', gender: male, father: king_arthur, mother: queen_margaret)
      percy          = Person.create(name: 'Percy', gender: male, father: king_arthur, mother: queen_margaret)
      ronald         = Person.create(name: 'Ronald', gender: male, father: king_arthur, mother: queen_margaret)
      ginerva        = Person.create(name: 'Ginerva', gender: female, father: king_arthur, mother: queen_margaret)

      # Second Generation - Spouses
      flora          = Person.create(name: 'Flora', gender: female, spouse: bill)
      audrey         = Person.create(name: 'Audrey', gender: female, spouse: percy)
      helen          = Person.create(name: 'Helen', gender: female, spouse: ronald)
      harry          = Person.create(name: 'Harry', gender: male, spouse: ginerva)

      # Third Generation
      victoire       = Person.create(name: 'Victoire', gender: female, father: bill, mother: flora)
      _              = Person.create(name: 'Dominique', gender: female, father: bill, mother: flora)
      _              = Person.create(name: 'Louis', gender: male, father: bill, mother: flora)

      _              = Person.create(name: 'Molly', gender: female, father: percy, mother: audrey)
      _              = Person.create(name: 'Lucy', gender: female, father: percy, mother: audrey)

      rose           = Person.create(name: 'Rose', gender: female, father: ronald, mother: helen)
      _              = Person.create(name: 'Hugo', gender: male, father: ronald, mother: helen)

      james          = Person.create(name: 'James', gender: male, father: harry, mother: ginerva)
      albus          = Person.create(name: 'Albus', gender: male, father: harry, mother: ginerva)
      _              = Person.create(name: 'Lily', gender: female, father: harry, mother: ginerva)

      # Third Generation - Spouses
      ted            = Person.create(name: 'Ted', gender: male, spouse: victoire)
      malfoy         = Person.create(name: 'Malfoy', gender: male, spouse: rose)

      darcy          = Person.create(name: 'Darcy', gender: female, spouse: james)
      alice          = Person.create(name: 'Alice', gender: female, spouse: albus)

      # Fourth Generation
      _              = Person.create(name: 'Remus', gender: male, father: ted, mother: victoire)

      _              = Person.create(name: 'Draco', gender: male, father: malfoy, mother: rose)
      _              = Person.create(name: 'Aster', gender: female, father: malfoy, mother: rose)

      _              = Person.create(name: 'William', gender: male, father: james, mother: darcy)

      _              = Person.create(name: 'Ron', gender: male, father: albus, mother: alice)
      _              = Person.create(name: 'Ginny', gender: female, father: albus, mother: alice)
    end
  end
end

