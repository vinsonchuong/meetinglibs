class EventsController < ApplicationController
  def index
    user_authenticator = UserAuthenticator.new(session)
    if user_authenticator.authenticated?
      render json: EventsPresenter.new(Event.all, user_authenticator)
    else
      head '401'
    end
  end
end
