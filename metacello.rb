$LOAD_PATH.unshift(File.expand_path("../lib", __FILE__))
require 'sinatra'
require 'haml'
require RUBY_ENGINE == "maglev" ? 'maruku' : 'markdown'
require 'coffee-script'
require 'compass'
require 'json'
require 'rack-flash'
require 'digest/md5'
require 'project'
require 'user'

enable :sessions
use Rack::Flash
use Authentication::Token

helpers do
  def gravatar(mail)
    mail ||= "jondoe@example.com"
    "http://www.gravatar.com/avatar/#{Digest::MD5::hexdigest(mail)}?s=40&d=wavatar"
  end
end

get '/' do
  if User.current_user?
    redirect "/dashboard/#{User.current_user.name}"
  else
    haml :dashboard, :locals => {:user => nil}
  end
end

get '/logout/?' do
  User.logout
  redirect "/"
end

post '/login/?' do
  u = params["user"]
  if session["auth-token"] = User.login(u["name"], u["password"])
    flash[:notice] = "You have been logged in."
  else
    session["new_user"] = {
      'name' => u["name"],
      'password' => u["password"]
    }.to_json
    flash[:notice] = haml(:"forms/signup", :layout => false,
      :locals => {:username => u["name"]})
  end
  redirect "/"
end

get "/signup/?" do
  if u = (params["new_user"] || session["new_user"])
    u = JSON.parse(u["new_user"])
    if !(u["name"] && u["password"])
      flash[:error] = "Signup failed. No username/password supplied!"
    elsif User.find(u["name"])
      flash[:error] = "Signup failed. A user with this name exists!"
    else
      User.new(u)
      session["auth-token"] = User.login(u["name"], u["password"])
      session.delete("new_user")
      flash[:notice] = "Signup successful, you are now logged in."
    end
  else
    flash[:error] = "Signup failed. No username/password supplied!"
  end
  redirect "/"
end

post "/account/?" do
  if User.current_user?
    user = User.current_user
    u = params["user"]
    user.update_from(params["user"])
    user.update_password(u["password"], u["new_password"], u["new_password_verficiation"])
    flash[:notice] = "Account update successful."
  else
    flash[:error] = "You are not logged in."
  end
  redirect "/"
end

get '/dashboard/:user/?' do |user|
  haml :dashboard, :locals => {:user => User.find(user)}
end

delete '/dashboard/:user/?' do |user|
  if User.current_user == User.find(user)
    u = User.current_user
    u.logout
    u.delete
    flash[:notice] = "Account deleted."
  else
    flash[:error] = "You are not logged in."
  end
  redirect "/"
end

get '/:name.st/?' do |name|
  if project = Project.find(name)
    project.doIt
  else
    redirect "/404"
  end
end

get '/:name/?' do |name|
  haml :project, :locals => { :user => User.current_user,
    :project => Project.find(name), :name => name }
end

post '/:name/?' do |name|
  if project = Project.find(name)
    project.update_from(params["project"])
    flash[:notice] = "Update successful"
  else
    flash[:error] = "Something went wrong while creating/updating the project."
  end
  redirect "/#{name}"
end

delete '/:name/?' do |name|
  if User.current_user && p = Project.find(name)
    p.delete
    flash[:notice] = "Project deleted."
  else
    flash[:error] = "You are not logged in."
  end
  redirect "/"
end

get '/register/:name' do |name|
  haml :"forms/project", :locals => { :project => Project.new(name) }
end

set :run, true
