class EventsPresenter
  def initialize(events, user_authenticator)
    @events = events
    @user_authenticator = user_authenticator
  end

  def as_json(options={})
    hosts = Host.where(user_id: @user_authenticator.user.id).group_by(&:event_id)
    visitors = Visitor.where(user_id: @user_authenticator.user.id).group_by(&:event_id)

    if @user_authenticator.administrator?
      @events.map do |e|
        {
          id: e.id, name: e.name, archived: e.archived?,
          host_id: hosts[e.id].try(:first).try(:id),
          visitor_id: visitors[e.id].try(:first).try(:id)
        }
      end
    else
      @events.reject(&:archived?).map do |e|
        {
          id: e.id, name: e.name,
          host_id: hosts[e.id].try(:first).try(:id),
          visitor_id: visitors[e.id].try(:first).try(:id)
        }
      end
    end
  end
end
