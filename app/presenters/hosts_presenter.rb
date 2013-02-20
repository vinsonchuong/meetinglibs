class HostsPresenter
  def initialize(hosts, user_authenticator)
    @hosts = hosts
    @user_authenticator = user_authenticator
  end

  def as_json(options={})
    if @user_authenticator.administrator?
      @hosts.map do |host|
        {
          id: host.id,
          first_name: host.user.first_name,
          last_name: host.user.last_name,
          email: host.user.email,
          cas_user: host.user.cas_user,
          token: host.user.token
        }
      end
    else
      @hosts.map do |host|
        {
          id: host.id,
          first_name: host.user.first_name,
          last_name: host.user.last_name
        }
      end
    end
  end
end
