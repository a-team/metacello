class MaglevModel
  DB = Maglev::PERSISTENT_ROOT

  def self.find(object_name)
    Maglev.abort_transaction
    DB[name] and DB[name][object_name]
  end

  # FIXME: What happens on transaction error?
  def save
    DB[self.class.name] ||= {}
    DB[self.class.name][name] = self
    Maglev.commit_transaction
  end

  def delete
    DB[self.class.name].delete(:name) if DB[self.class.name]
    Maglev.commit_transaction
  end

  def self.inherited(clazz)
    clazz.maglev_persistable
  end
end

