class VisitorsController < ApplicationController
  before_filter :require_authentication
  before_filter :require_administrator, except: [:index, :create]

  respond_to :json

  def index
    respond_with VisitorsPresenter.new(event.visitors.with_contact_info, user_authenticator)
  end

  def create
    validate_input_with(VisitorInput, user_authenticator) do |attributes|
      respond_with VisitorPresenter.new(event.visitors.create(attributes)), location: nil
    end
  end

  def update
    validate_input_with(VisitorInput, user_authenticator) do |attributes|
      respond_with event.visitors.find(params[:id]).update_attributes(attributes)
    end
  end

  def destroy
    respond_with event.visitors.find(params[:id]).destroy
  end
end
