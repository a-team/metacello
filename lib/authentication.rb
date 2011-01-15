require 'try'

class AuthenticationError < Exception
end

module Authentication
  def current_user
    return nil unless session["auth_token"]
    Token.find(session["auth_token"]).try(:user)
  end

  def current_user?
    !!current_user
  end

  def login(username, password)
    user = User.find(username)
    !!user.try(:authenticate, password) ? Token.new(user).save : nil
  end

  def logout
    Token.find(session["auth_token"]).try(:delete)
  end
end
