require 'try'

module Authentication
  class Token
    def initialize(app, opts = {})
      @app = app
    end

    def call(env)
      Thread.current["auth-token"] = env["rack.session"]["auth-token"]
      @app.call(env)
    end
  end

  def auth_token
    Thread.current["auth-token"]
  end

  def current_user
    return nil unless auth_token
    Token.find(auth_token).try(:user)
  end

  def current_user?
    !!current_user
  end

  def login(username, password)
    user = User.find(username)
    !!user.try(:authenticate, password) ? Token.new(user).name : nil
  end

  def logout
    Token.find(auth_token).try(:delete) if auth_token
  end
end
