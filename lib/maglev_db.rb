class MaglevDB
  DB = Maglev::PERSISTENT_ROOT

  def find(db, token)
    Maglev.abort_transaction
    DB[db] and DB[db][token]
  end

  # FIXME: What happens on transaction abort?
  def save(db, object)
    Maglev.transaction { DB[db][object.token] = object }
    object
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
