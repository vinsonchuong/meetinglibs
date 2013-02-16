class EventsPresenter
  def initialize(events, user_authenticator)
    @events = events
    @user_authenticator = user_authenticator
  end

  def as_json(options={})
    if @user_authenticator.administrator?
      @events.map {|e| {id: e.id, name: e.name, archived: e.archived?} }
    else
      @events.reject(&:archived?).map {|e| {id: e.id, name: e.name} }
    end
  end
end
