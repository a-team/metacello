require 'bcrypt'
require 'model'
require 'authentication'

class User < Model
  extend Authentication

  attr_accessor :name, :mail, :url, :password_hash
  attr_reader :token

  def initialize(hash)
    update_from(hash)
  end

  def authenticate(password)
    BCrypt::Password.new(password_hash) == password
  end

  def password=(pw)
    self.password_hash = BCrypt::Password.create(pw).to_s
  end

  def update_from(hash)
    ["name", "mail", "url", "password"].each do |option|
      self.send(:"#{option}=", hash[option])
    end
    save
  end

  def update_password(old_pw, new_pw, new_pw_verification)
    if authenticate(old_pw) && new_pw
      self.password = new_pw if new_pw == new_pw_verification
      save
    else
      false
    end
  end
end
