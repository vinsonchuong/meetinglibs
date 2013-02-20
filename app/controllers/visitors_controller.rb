class VisitorsController < ApplicationController
  before_filter :require_authentication
  before_filter :require_administrator, except: :index

  respond_to :json

  def index
    respond_with VisitorsPresenter.new(Event.find(params[:event_id]).visitors.with_contact_info, user_authenticator)
  end

  def create
    validate_input_with(VisitorInput) do |attributes|
      respond_with VisitorPresenter.new(Event.find(params[:event_id]).visitors.create(attributes)), location: nil
    end
  end

  def update
    validate_input_with(VisitorInput) do |attributes|
      respond_with Event.find(params[:event_id]).visitors.find(params[:id]).update_attributes(attributes)
    end
  end

  def destroy
    respond_with Event.find(params[:event_id]).visitors.find(params[:id]).destroy
  end
end
