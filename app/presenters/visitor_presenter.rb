class VisitorPresenter
  def self.model_name
    Visitor.model_name
  end

  def initialize(visitor, user_authenticator)
    @visitor = visitor
    @user_authenticator = user_authenticator
  end

  def as_json(options={})
    if @user_authenticator.administrator?
      {
        id: @visitor.id,
        first_name: @visitor.user.first_name,
        last_name: @visitor.user.last_name,
        email: @visitor.user.email,
        cas_user: @visitor.user.cas_user,
        token: @visitor.user.token
      }
    else
      {
        id: @visitor.id,
        first_name: @visitor.user.first_name,
        last_name: @visitor.user.last_name,
        email: @visitor.user.email
      }
    end
  end
end
