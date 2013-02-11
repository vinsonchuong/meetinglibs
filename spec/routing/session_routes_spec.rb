require 'spec_helper'

describe 'Session Routes' do
  describe 'get /session/new' do
    it 'should route to SessionsController#new' do
      expect(get: '/session/new').to route_to controller: 'sessions', action: 'new'
    end
  end

  describe 'post /session' do
    it 'should route to SessionsController#create' do
      expect(post: '/session').to route_to controller: 'sessions', action: 'create'
    end
  end

  describe 'get /session/calnet' do
    it 'should route to SessionsController#calnet' do
      expect(get: '/session/calnet').to route_to controller: 'sessions', action: 'calnet'
    end
  end

  describe 'get /' do
    it 'should route to SessionsController#show' do
      expect(get: '/').to route_to controller: 'sessions', action: 'show'
    end
  end

  describe 'delete /session' do
    it 'should route to SessionsController#destroy' do
      expect(delete: '/session').to route_to controller: 'sessions', action: 'destroy'
    end
  end
end
