class SessionsController < ApplicationController
  before_filter RubyCAS::Filter, only: :calnet

  def new
  end

  def calnet
    session[:user_id] = User.where(cas_user: session[:cas_user]).first.id
    redirect_to action: :show
  end

  def create
    @token = params[:token]
    user = User.where(token: @token).first
    if user.present?
      session[:user_id] = user.id
      redirect_to action: :show
    else
      flash.now[:error] = 'invalid token'
      render action: :new
    end
  end

  def show
    redirect_to action: :new if session[:user_id].blank?
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
