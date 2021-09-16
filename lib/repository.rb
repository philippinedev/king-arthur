class Repository
  class << self
    def create(params)
      new(params).save
    end

    def all
      self.store.values
    end

    def count
      self.store.count
    end

    def last
      self.store[self.store.keys.last]
    end

    def find(id)
      store[id.to_s]
    end

    def where(params)
      # ID conditions
      key = params.keys
        .map { |x| x.to_s }
        .filter { |x| x.end_with? "_id" }
        .first

      if key
        key_cond = key.split("_").map { |x| x.to_sym }
        key_value = params[key.to_sym]
      end

      # Non-ID conditions
      non_id_keys = params.keys
        .map { |x| x.to_s }
        .reject { |x| x.end_with? "_id" }
        .map { |x| x.to_sym }

      non_id_conds = non_id_keys.map { |key| Hash[key, params[key]] }

      tmp = store.values

      if key
        tmp = tmp.filter { |a| a.send(key_cond[0])&.id == key_value }
      end

      non_id_conds.each do |cond|
        tmp = tmp.filter { |a| a.send(cond.first[0]) == cond.first[1] }
      end

      tmp
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
    after_save
    self
  end

  def after_save
    self.id = new_id
    store[self.id.to_s] = self
  end

  def id
    keys.first.to_s.to_i
  end

  private

  def new_id
    return 1 if self.class.store.count == 0
    self.class.last.id + 1
  end

  def store
    self.class.store
  end
end

