class VisitorPresenter
  def self.model_name
    Visitor.model_name
  end

  def initialize(visitor)
    @visitor = visitor
  end

  def as_json(options={})
    {
      id: @visitor.id,
      first_name: @visitor.user.first_name,
      last_name: @visitor.user.last_name,
      email: @visitor.user.email,
      cas_user: @visitor.user.cas_user,
      token: @visitor.user.token
    }
  end
end
