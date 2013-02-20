class HostsController < ApplicationController
  before_filter :require_authentication
  before_filter :require_administrator, except: [:index, :create]

  respond_to :json

  def index
    respond_with HostsPresenter.new(event.hosts.with_contact_info, user_authenticator)
  end

  def create
    validate_input_with(HostInput, user_authenticator) do |attributes|
      respond_with HostPresenter.new(event.hosts.create(attributes)), location: nil
    end
  end

  def update
    validate_input_with(HostInput, user_authenticator) do |attributes|
      respond_with event.hosts.find(params[:id]).update_attributes(attributes)
    end
  end

  def destroy
    respond_with event.hosts.find(params[:id]).destroy
  end
end
