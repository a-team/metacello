class User
  attr_accessor :name, :mail, :url, :password_hash
  attr_reader :token

  def token
    @token ||= name.hash
  end
end
