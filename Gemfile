source :rubygems
gem "rack-flash"
gem "sinatra"
gem "haml"
gem "compass"
gem "coffee-script"
if RUBY_ENGINE =~ /maglev/
  gem "json_pure"
  gem "maruku"
  gem "bcrypt-ruby", :git => "git://github.com/timfel/bcrypt-ruby.git", :branch => "fixed-gemspec"
else
  gem "json"
  gem "rdiscount"
  gem "bcrypt-ruby"
end

