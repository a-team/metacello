require 'bcrypt'

class User
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
  end

  def token
    @token ||= name.hash
  end
end
