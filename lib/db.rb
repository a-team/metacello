if RUBY_ENGINE == "maglev"
  require File.expand_path("../db/maglev_db", __FILE__)
  DB = MaglevDB
else
  require File.expand_path("../db/pstore_db", __FILE__)
  DB = PstoreDB
end

