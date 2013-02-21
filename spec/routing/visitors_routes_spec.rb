require 'spec_helper'

describe 'Visitors Routes' do
  describe 'get /events/1/visitors' do
    it 'should route to VisitorsController#index' do
      expect(get: '/events/1/visitors').to route_to(controller: 'visitors', action: 'index', event_id: '1', format: :json)
    end
  end

  describe 'get /events/1/visitors/1' do
    it 'should route to VisitorsController#show' do
      expect(get: '/events/1/visitors/1').to route_to(controller: 'visitors', action: 'show', event_id: '1', id: '1', format: :json)
    end
  end

  describe 'post /events/1/visitors' do
    it 'should route to VisitorsController#create' do
      expect(post: '/events/1/visitors').to route_to(controller: 'visitors', action: 'create', event_id: '1', format: :json)
    end
  end

  describe 'put /events/1/visitors/1' do
    it 'should route to VisitorsController#update' do
      expect(put: '/events/1/visitors/1').to route_to(controller: 'visitors', action: 'update', event_id: '1', id: '1', format: :json)
    end
  end

  describe 'delete /events/1/visitors/1' do
    it 'should route to VisitorsController#destroy' do
      expect(delete: '/events/1/visitors/1').to route_to(controller: 'visitors', action: 'destroy', event_id: '1', id: '1', format: :json)
    end
  end
end
