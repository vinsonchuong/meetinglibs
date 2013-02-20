require 'spec_helper'

describe 'Hosts Routes' do
  describe 'get /events/1/hosts' do
    it 'should route to HostsController#index' do
      expect(get: '/events/1/hosts').to route_to(controller: 'hosts', action: 'index', event_id: '1', format: :json)
    end
  end

  describe 'post /events/1/hosts' do
    it 'should route to HostsController#create' do
      expect(post: '/events/1/hosts').to route_to(controller: 'hosts', action: 'create', event_id: '1', format: :json)
    end
  end

  describe 'put /events/1/hosts/1' do
    it 'should route to HostsController#update' do
      expect(put: '/events/1/hosts/1').to route_to(controller: 'hosts', action: 'update', event_id: '1', id: '1', format: :json)
    end
  end

  describe 'delete /events/1/hosts/1' do
    it 'should route to HostsController#destroy' do
      expect(delete: '/events/1/hosts/1').to route_to(controller: 'hosts', action: 'destroy', event_id: '1', id: '1', format: :json)
    end
  end
end
