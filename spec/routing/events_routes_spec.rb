require 'spec_helper'

describe 'Events Routes' do
  describe 'get /events' do
    it 'should route to EventsController#index' do
      expect(get: '/events').to route_to(controller: 'events', action: 'index', format: :json)
    end
  end

  describe 'put /events/1' do
    it 'should route to EventsController#update' do
      expect(put: '/events/1').to route_to(controller: 'events', action: 'update', id: '1', format: :json)
    end
  end
end
