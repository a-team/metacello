require 'pstore'

class PstoreModel
  DB = PStore.new("persistent_root")

  def self.find(object_name)
    DB.transaction(true) { DB[name] and DB[name][object_name] }
  end

  # FIXME: What happens on transaction abort?
  def save
    DB.transaction do
      DB[self.class.name] ||= {}
      DB[self.class.name][name] = self
    end
  end

  def delete
    DB.transaction do
      DB[self.class.name].delete(:name) if DB[self.class.name]
    end
  end
end

