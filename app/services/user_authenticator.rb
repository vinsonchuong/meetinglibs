class UserAuthenticator
  attr_reader :user, :host, :visitor

  def initialize(session, event=nil)
    @session = session
    @user = User.where(id: @session[:user_id]).first
    @event = event
  end

  def authenticated?
    @user.present?
  end

  def administrator?
    @user.administrator?
  end

  def participant?
    host? || visitor?
  end

  def host
    @host ||= @user.present? && @event.present? && @event.hosts.where(user_id: @user.id).first
  end

  def visitor
    @visitor ||= @user.present? && @event.present? && @event.visitors.where(user_id: @user.id).first
  end

  def host?
    host.present?
  end

  def visitor?
    visitor.present?
  end

  def authenticate!(credentials)
    if credentials.has_key?(:cas_user)
      @user = User.where(cas_user: credentials[:cas_user]).first_or_create
    elsif credentials.has_key?(:token)
      @user = User.where(token: credentials[:token]).first
    end

    @session[:user_id] = @user.id if @user.present?
  end
end
