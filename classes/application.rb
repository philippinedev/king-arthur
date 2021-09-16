class Application
  class << self
    def start!
      Seed.call
    end

    def transformers
      [
        GetRelationshipTransformer,
        AddChildTransformer
      ]
    end
  end
end

