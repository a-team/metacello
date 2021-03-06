class MaglevModel
  DB = Maglev::PERSISTENT_ROOT

  def self.find(object_name)
    Maglev.abort_transaction
    DB[name] and DB[name][object_name]
  end

  def self.all
    Maglev.abort_transaction
    DB[name] ? DB[name].values : []
  end

  # FIXME: What happens on transaction error?
  def save
    self.class.persistable
    DB[self.class.name] ||= {}
    DB[self.class.name][name] = self
    Maglev.commit_transaction
  end

  def delete
    DB[self.class.name].delete(@name) if DB[self.class.name]
    Maglev.commit_transaction
  end

  def self.persistable
    self.maglev_persistable unless self.maglev_persistable?
  end
end

MaglevModel.maglev_persistable
