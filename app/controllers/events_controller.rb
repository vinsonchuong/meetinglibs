class EventsController < ApplicationController
  before_filter :require_authentication
  before_filter :require_administrator, except: :index

  respond_to :json

  def index
    respond_with EventsPresenter.new(Event.all, user_authenticator)
  end

  def create
    validate_input_with(EventInput) do |attributes|
      respond_with EventPresenter.new(Event.create(attributes))
    end
  end

  def update
    validate_input_with(EventInput) do |attributes|
      respond_with Event.find(params[:id]).update_attributes(attributes), location: nil
    end
  end

  def destroy
    respond_with Event.find(params[:id]).destroy
  end
end
