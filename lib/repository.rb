class Repository
  class << self
    def create(params)
      new(params).save
    end

    def count
      self.store.count
    end

    def find(id)
      store[id.to_s]
    end

    def store
      @@store = {}        if defined?(@@store).nil?
      @@store[table] = {} if @@store[table].nil?

      @@store[table]
    end

    def clear!
      @@store = {}
    end

    private

    def table
      name.downcase.to_sym
    end
  end

  def save
    store['1'] = self
  end

  private

  def store
    self.class.store
  end
end

