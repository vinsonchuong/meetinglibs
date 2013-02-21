class HostPresenter
  def self.model_name
    Host.model_name
  end

  def initialize(host, user_authenticator)
    @host = host
    @user_authenticator = user_authenticator
  end

  def as_json(options={})
    if @user_authenticator.administrator?
      {
        id: @host.id,
        first_name: @host.user.first_name,
        last_name: @host.user.last_name,
        email: @host.user.email,
        cas_user: @host.user.cas_user,
        token: @host.user.token
      }
    else
      {
        id: @host.id,
        first_name: @host.user.first_name,
        last_name: @host.user.last_name,
        email: @host.user.email
      }
    end
  end
end
