class HostsController < ApplicationController
  before_filter :require_authentication
  before_filter :require_administrator, except: :index

  respond_to :json

  def index
    respond_with HostsPresenter.new(Event.find(params[:event_id]).hosts.with_contact_info, user_authenticator)
  end

  def create
    validate_input_with(HostInput) do |attributes|
      respond_with HostPresenter.new(Event.find(params[:event_id]).hosts.create(attributes)), location: nil
    end
  end

  def update
    validate_input_with(HostInput) do |attributes|
      respond_with Event.find(params[:event_id]).hosts.find(params[:id]).update_attributes(attributes)
    end
  end

  def destroy
    respond_with Event.find(params[:event_id]).hosts.find(params[:id]).destroy
  end
end
