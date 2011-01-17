require 'model'

class Token < Model
  attr_reader :name, :user

  def initialize(user)
    @user = user
    @name = BCrypt::Password.create(object.inspect).to_s
    save
  end
end
