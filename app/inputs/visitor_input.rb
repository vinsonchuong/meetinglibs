class VisitorInput
  include ActiveModel::Validations

  attr_reader :first_name, :last_name, :email, :cas_user, :token

  validates_presence_of :first_name, :last_name, :email

  def initialize(params, user_authenticator)
    @id = params[:id]
    @first_name = params[:first_name]
    @last_name = params[:last_name]
    @email = params[:email]
    @cas_user = params[:cas_user]
    @token = params[:token]
    @user_authenticator = user_authenticator
  end

  def attributes
    {user_attributes: {
      first_name: first_name,
      last_name: last_name,
      email: email,
      cas_user: cas_user,
      token: token
    }}.tap do |attributes|
      if @id.present?
        user = Visitor.find(@id).user
        attributes[:user_attributes][:id] = user.id
      elsif !@user_authenticator.administrator?
        attributes[:user_attributes][:id] = attributes[:user_id] = @user_authenticator.user.id
      elsif (user = User.where(cas_user: cas_user).first).present?
        attributes[:user_attributes][:id] = attributes[:user_id] = user.id
      end
    end
  end
end
