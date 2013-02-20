class ApplicationController < ActionController::Base
  protect_from_forgery

  private

  def require_authentication
    head :unauthorized unless user_authenticator.authenticated?
  end

  def require_administrator
    head :unauthorized unless user_authenticator.administrator?
  end

  def user_authenticator
    @user_authenticator ||= UserAuthenticator.new(session, event)
  end

  def event
    @event ||= params[:event_id].present? && Event.find(params[:event_id])
  end

  def validate_input_with(input_class, *arguments)
    input = input_class.new(params, *arguments)
    if input.valid?
      yield input.attributes
    else
      head :bad_request
    end
  end
end
