class User
  attr_accessor :name, :mail, :url, :password_hash
  attr_reader :token

  Crypt3Method = :sha512

  def initialize(hash)
    update_from(hash)
  end

  def authenticate(password)
    Crypt3.check(password, password_hash, Crypt3Method)
  end

  def password=(pw)
    Crypt3.create(pw, Crypt3Method)
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
