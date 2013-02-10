class UserAuthenticator
  attr_reader :user

  def initialize(session)
    @session = session
    @user = User.where(id: @session[:user_id]).first
  end

  def authenticated?
    @user.present?
  end

  def authenticate!(credentials)
    if credentials.has_key?(:cas_user)
      @user = User.where(cas_user: credentials[:cas_user]).first
    elsif credentials.has_key?(:token)
      @user = User.where(token: credentials[:token]).first
    end

    @session[:user_id] = @user.id if @user.present?
  end
end
