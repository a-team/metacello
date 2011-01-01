class MaglevDB
  DB = Maglev::PERSISTENT_ROOT

  def self.find(db, name)
    Maglev.abort_transaction
    DB[db] and DB[db][name.hash]
  end

  # FIXME: What happens on transaction error?
  def self.save(db, object)
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

