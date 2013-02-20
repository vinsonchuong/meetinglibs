class HostInput
  include ActiveModel::Validations

  attr_reader :first_name, :last_name, :email, :cas_user, :token

  validates_presence_of :first_name, :last_name, :email

  def initialize(params)
    @first_name = params[:first_name]
    @last_name = params[:last_name]
    @email = params[:email]
    @cas_user = params[:cas_user]
    @token = params[:token]
  end

  def attributes
    {user_attributes: {
      first_name: first_name,
      last_name: last_name,
      email: email,
      cas_user: cas_user,
      token: token
    }}
  end
end
