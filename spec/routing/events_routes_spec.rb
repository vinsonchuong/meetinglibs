require 'spec_helper'

describe 'Events Routes' do
  describe 'get /events' do
    it 'should route to EventsController#index' do
      expect(get: '/events').to route_to(controller: 'events', action: 'index')
    end
  end
end
