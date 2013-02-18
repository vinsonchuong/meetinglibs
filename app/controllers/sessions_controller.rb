class SessionsController < ApplicationController
  before_filter RubyCAS::Filter, only: :calnet

  def new
  end

  def calnet
    authenticator = UserAuthenticator.new(session)
    if authenticator.authenticate!(cas_user: session[:cas_user])
      redirect_to action: :show
    end
  end

  def create
    @token = params[:token]
    authenticator = UserAuthenticator.new(session)
    if authenticator.authenticate!(token: @token)
      redirect_to action: :show
    else
      flash.now[:error] = 'invalid token'
      render action: :new
    end
  end

  def show
    user_authenticator = UserAuthenticator.new(session)
    if user_authenticator.authenticated?
      @administrator = user_authenticator.administrator?
    else
      redirect_to action: :new
    end
  end

  def destroy
    if session[:cas_user].present?
      RubyCAS::Filter.logout(self)
    else
      reset_session
      redirect_to action: :new
    end
  end
end
