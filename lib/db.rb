if RUBY_ENGINE == "maglev"
  require File.expand_path("../maglev_db", __FILE__)
else
  require File.expand_path("../pstore_db", __FILE__)
end

