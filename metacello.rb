require 'sinatra'
require 'haml'
require 'compass'
require 'mongo'
require 'bcrypt'

DB = Mongo::Connection.new(ENV['DATABASE_URL'] || 'localhost').db('metacello')
if ENV['DATABASE_USER'] && ENV['DATABASE_PASSWORD']
  auth = DB.authenticate(ENV['DATABASE_USER'], ENV['DATABASE_PASSWORD'])
end

enable :sessions

helpers do
  def current_user;   find_user(session['username']) || {};  end
  def save(db, hash); DB[db].insert(hash);                  end
  def find(db, name); DB[db].find_one('name' => name);      end

  %w[project user].each do |tbl|
    define_method(:"find_#{tbl}") {|name| find("#{tbl}s", name) }

    define_method(:"save_#{tbl}") do |hash|
      return save("#{tbl}s", hash) unless send(:"find_#{tbl}", hash['name'])
      false
    end
  end

  def gravatar(mail)
    "<img src='http://www.gravatar.com/avatar/#{MD5::md5(mail)}?s=80&d=wavatar"'
      alt='' width='#{size}' height='#{size}' class='gravatar'>"
  end
end

get '/' do
  if current_user
    redirect '/#{current_user.name}'
  else
    haml :dashboard
  end
end

get '/logout/?' do
  session.delete('username')
  redirect "/"
end

post '/(login|signup)/?' do
  if user = find_user(params["user"]["name"])
    if BCrypt::Password.new(user['password_hash']) == params["user"]["password"]
      session["username"] = params["user"]["name"]
      redirect "/"
    end
  else
    user = {
      'name' => params["user"]["name"],
      'password_hash' => BCrypt::Password.create(params["user"]["password"]).to_s
    }
    save_user(user)
    session["username"] = user['name']
    redirect "/"
  end
  redirect "/"
end

get '/dashboard/:user/?' do |user|
end

delete '/dashboard/:user/?' do |user|
end

get '/:name/?' do |name|
end

post '/:name/?' do |name|
end

delete '/:name/?' do |name|
end

get "/stylesheets/screen.css" do
  content_type 'text/css'

  # Use views/stylesheets & blueprint's stylesheet dirs in the Sass load path
  sass :"stylesheets/screen", { :sass => { :load_paths => (
    [ File.join(File.dirname(__FILE__), 'views', 'stylesheets') ] +
    Compass::Frameworks::ALL.map { |f| f.stylesheets_directory })
  } }
end

