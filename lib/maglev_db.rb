class MaglevDB
  DB = Maglev::PERSISTENT_ROOT

  def find(db, name)
    Maglev.abort_transaction
    DB[db] and DB[db][name]
  end

  def save(db, object)
    Maglev.transaction { DB[db][name] = object }
  end

  def method_missing(method, *args, &block)
    if method =~ /^find_([a-z]*)$/
      find("#{$1}", *args)
    elsif method =~ /^save_([a-z]*)$/
      save("#{$1}", *args)
    else
      super
    end
  end
end
