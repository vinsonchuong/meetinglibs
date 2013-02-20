class VisitorsPresenter
  def initialize(visitors, user_authenticator)
    @visitors = visitors
    @user_authenticator = user_authenticator
  end

  def as_json(options={})
    if @user_authenticator.administrator?
      @visitors.map do |visitor|
        {
          id: visitor.id,
          first_name: visitor.user.first_name,
          last_name: visitor.user.last_name,
          email: visitor.user.email,
          cas_user: visitor.user.cas_user,
          token: visitor.user.token
        }
      end
    else
      @visitors.map do |visitor|
        {
          id: visitor.id,
          first_name: visitor.user.first_name,
          last_name: visitor.user.last_name
        }
      end
    end
  end
end
