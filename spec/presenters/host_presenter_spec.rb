require 'spec_helper'

describe HostPresenter do
  subject { HostPresenter.new(host, user_authenticator) }
  let(:host) { event.hosts.create!(user_attributes: {first_name: 'John', last_name: 'Doe', email: 'jd@example.com', cas_user: '111'}) }
  let(:event) { Event.create!(name: 'Event', archived: false) }

  context 'as an administrator' do
    let(:user_authenticator) { mock(UserAuthenticator, administrator?: true) }

    it 'should present all the attributes of the host' do
      expect(subject.as_json).to eq(id: host.id, first_name: 'John', last_name: 'Doe', email: 'jd@example.com', cas_user: '111', token: nil)
    end
  end

  context 'as a user' do
    let(:user_authenticator) { mock(UserAuthenticator, administrator?: false) }

    it 'should present the non-login attributes of the host' do
      expect(subject.as_json).to eq(id: host.id, first_name: 'John', last_name: 'Doe', email: 'jd@example.com')
    end
  end
end
