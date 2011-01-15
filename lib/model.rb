if RUBY_ENGINE == "maglev"
  require File.expand_path("../model/maglev_model", __FILE__)
  Model = MaglevModel
  Maglev.commit_transaction
else
  require File.expand_path("../model/pstore_model", __FILE__)
  Model = PstoreModel
end

