class MaglevDB
  DB = Maglev::PERSISTENT_ROOT

  def self.find(db, token)
    Maglev.abort_transaction
    DB[db] and DB[db][token]
  end

  # FIXME: What happens on transaction abort?
  def self.save(db, object)
    Maglev.abort_transaction
    DB[db] ||= {}
    DB[db][object.token] = object
    Maglev.commit_transaction
    object
  end

  def self.method_missing(method, *args, &block)
    if method.to_s =~ /^find_([a-z]*)$/
      find("#{$1}", *args)
    elsif method.to_s =~ /^save_([a-z]*)$/
      save("#{$1}", *args)
    else
      super
    end
  end
end

