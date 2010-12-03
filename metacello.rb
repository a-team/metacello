require 'sinatra'
require 'haml'
require 'compass'
require 'mongo'
require 'bcrypt'
require 'json'
require 'rack-flash'
require 'digest/md5'
require 'coffee-script'

DB = Mongo::Connection.new(ENV['DATABASE_URL'] || 'localhost').db('metacello')
if ENV['DATABASE_USER'] && ENV['DATABASE_PASSWORD']
  auth = DB.authenticate(ENV['DATABASE_USER'], ENV['DATABASE_PASSWORD'])
end

enable :sessions
use Rack::Flash

helpers do
  def current_user;      find_user(session['username']) || {};  end
  def current_user?;     !!find_user(session['username']);      end
  def current_user=name; session['username'] = name;            end

  def find(db, name); DB[db].find_one('name' => name);      end
  def save(db, hash)
    if document = find(db, name)
      DB[db].update({"name" => name}, document.merge(hash))
    else
      DB[db].insert(hash)
    end
  end

  %w[project user].each do |tbl|
    define_method(:"find_#{tbl}") {|name| find("#{tbl}s", name) }

    define_method(:"save_#{tbl}") do |hash|
      return save("#{tbl}s", hash) unless send(:"find_#{tbl}", hash['name'])
      false
    end
  end

  def gravatar(mail)
    mail ||= "jondoe@example.com"
    "http://www.gravatar.com/avatar/#{Digest::MD5::hexdigest(mail)}?s=40&d=wavatar"
  end
end

get '/' do
  if current_user?
    redirect "/dashboard/#{current_user['name']}"
  else
    haml :dashboard, :locals => {:user => nil}
  end
end

get '/logout/?' do
  self.current_user = nil
  redirect "/"
end

post '/login/?' do
  if user = find_user(params["user"]["name"])
    if BCrypt::Password.new(user['password_hash']) == params["user"]["password"]
      self.current_user = params["user"]["name"]
      flash[:notice] = "You have been logged in."
    end
  else
    session["new_user"] = {
      'name' => params["user"]["name"],
      'password_hash' => BCrypt::Password.create(params["user"]["password"]).to_s
    }.to_json
    flash[:notice] = haml(:"forms/signup", :layout => false,
      :locals => {:username => params["user"]["name"]})
  end
  flash[:error] = "Something went wrong."
  p "GOT HERE"
  redirect "/"
end

get "/signup/?" do
  if session["new_user"]
    user = JSON.parse(session["new_user"])
    unless find_user(user["name"])
      save_user(user)
      self.current_user = user["name"]
      session.delete("new_user")
      flash[:notice] = "Signup successful"
    else
      flash[:error] = "Signup failed. A user with this name exists!"
    end
  end
  flash[:error] = "Signup failed. No username/password supplied!"
  redirect "/"
end

post "/account/?" do
  if current_user?
    user = current_user
    if BCrypt::Password.new(user['password_hash']) == params["user"]["password"]
      user["mail"] = params["user"]["mail"]
      user["homepage"] = params["user"]["homepage"]
      if params["user"]["new_password"] and params["user"]["new_password"] == params["user"]["new_password_verification"]
        user["password_hash"] = BCrypt::Password.create(params["user"]["password"]).to_s
      end
      save_user(user)
      flash[:notice] = "Account update successful"
    end
    flash[:error] = "The password is wrong!"
  end
  flash[:error] = "An error has occured. Please try logging in again."
  redirect "/"
end

get '/dashboard/:user/?' do |user|
  haml :dashboard, :locals => {:user => find_user(user)}
end

delete '/dashboard/:user/?' do |user|
end

get '/:name/?' do |name|
end

post '/:name/?' do |name|
end

delete '/:name/?' do |name|
end

get "/stylesheets/:name.css" do |name|
  sass :"stylesheets/#{name}", { :sass => { :load_paths => (
    [ File.join(File.dirname(__FILE__), 'views', 'stylesheets') ] +
    Compass::Frameworks::ALL.map { |f| f.stylesheets_directory })
  } }
end

get "/javascript/:name.js" do |name|
  coffee :"javascript/#{name}"
end

