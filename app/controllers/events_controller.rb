class EventsController < ApplicationController
  before_filter :require_authentication
  before_filter :require_administrator, only: :update

  respond_to :json

  def index
    respond_with EventsPresenter.new(Event.all, user_authenticator)
  end

  def update
    validate_input_with(EventInput) do |attributes|
      respond_with Event.find(params[:id]).update_attributes(attributes)
    end
  end
end
