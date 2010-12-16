if RUBY_ENGINE == "maglev"
  require File.expand_path("../db/maglev_db", __FILE__)
  DB = MaglevDB
  Project.maglev_persistable
  User.maglev_persistable
  Maglev.commit_transaction
else
  require File.expand_path("../db/pstore_db", __FILE__)
  DB = PstoreDB
end

