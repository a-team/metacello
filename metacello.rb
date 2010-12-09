require 'sinatra'
require 'haml'
require 'coffee-script'
require 'compass'
require 'json'
require 'rack-flash'
require 'digest/md5'
require 'crypt3'
require 'lib/maglev_db'

enable :sessions
use Rack::Flash

helpers do
  def current_user;      DB.find_user(session['token'])           end
  def current_user?;     !!session['token']                       end
  def current_user=name
    session['token'] = DB.find_user(name).token
  end

  def gravatar(mail)
    mail ||= "jondoe@example.com"
    "http://www.gravatar.com/avatar/#{Digest::MD5::hexdigest(mail)}?s=40&d=wavatar"
  end
end

get '/' do
  if current_user?
    redirect "/dashboard/#{current_user.name}"
  else
    haml :dashboard, :locals => {:user => nil}
  end
end

get '/logout/?' do
  self.current_user = nil
  redirect "/"
end

post '/login/?' do
  if user = DB.find_user(params["user"]["name"])
    if Crypt3.check(params["user"]["password"], user.password_hash, :sha512)
      self.current_user = params["user"]["name"]
      flash[:notice] = "You have been logged in."
    end
  else
    session["new_user"] = {
      'name' => params["user"]["name"],
      'password_hash' => Crypt3.create(params["user"]["password"], :sha512)
    }.to_json
    flash[:notice] = haml(:"forms/signup", :layout => false,
      :locals => {:username => params["user"]["name"]})
  end
  flash[:error] = "Something went wrong."
  redirect "/"
end

get "/signup/?" do
  if session["new_user"]
    user = JSON.parse(session["new_user"])
    unless DB.find_user(user["name"])
      DB.save_user(user)
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
    if Crypt3.check(params["user"]["password"], user.password_hash, :sha512)
      user["mail"] = params["user"]["mail"]
      user["homepage"] = params["user"]["homepage"]
      if params["user"]["new_password"] and params["user"]["new_password"] == params["user"]["new_password_verification"]
        user["password_hash"] = Crypt3.create(params["user"]["password"], :sha512)
      end
      DB.save_user(user)
      flash[:notice] = "Account update successful"
    end
    flash[:error] = "The password is wrong!"
  end
  flash[:error] = "An error has occured. Please try logging in again."
  redirect "/"
end

get '/dashboard/:user/?' do |user|
  haml :dashboard, :locals => {:user => DB.find_user(user)}
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

set :run, true
