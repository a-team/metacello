require 'pstore'

class PstoreDB
  DB = PStore.new("persistent_root")

  def find(db, token)
    DB.transaction(true) { DB[db] and DB[db][token] }
  end

  # FIXME: What happens on transaction abort?
  def save(db, object)
    DB.transaction { DB[db][object.token] = object }
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

Object::DB = PstoreDB.new
