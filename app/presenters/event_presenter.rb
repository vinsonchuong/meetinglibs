class EventPresenter
  def self.model_name
    Event.model_name
  end

  def initialize(event)
    @event = event
  end

  def as_json(options={})
    {
      id: @event.id,
      name: @event.name,
      archived: @event.archived?
    }
  end
end
