class HostPresenter
  def self.model_name
    Host.model_name
  end

  def initialize(host)
    @host = host
  end

  def as_json(options={})
    {
      id: @host.id,
      first_name: @host.user.first_name,
      last_name: @host.user.last_name,
      email: @host.user.email,
      cas_user: @host.user.cas_user,
      token: @host.user.token
    }
  end
end
