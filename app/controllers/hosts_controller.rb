class HostsController < ApplicationController
  before_filter :require_authentication
  before_filter :require_administrator_or_not_participant, only: :create
  before_filter :require_administrator, only: :destroy
  before_filter :require_administrator_or_self, only: [:show, :update]

  respond_to :json

  def index
    respond_with HostsPresenter.new(event.hosts.with_contact_info, user_authenticator)
  end

  def show
    respond_with HostPresenter.new(event.hosts.find(params[:id]), user_authenticator)
  end

  def create
    validate_input_with(HostInput, user_authenticator) do |attributes|
      respond_with HostPresenter.new(event.hosts.create(attributes), user_authenticator), location: nil
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

  private

  def require_administrator_or_self
    head :unauthorized unless user_authenticator.administrator? || user_authenticator.host.id == params[:id].to_i
  end

  def require_administrator_or_not_participant
    head :unauthorized unless user_authenticator.administrator? || !user_authenticator.participant?
  end
end
