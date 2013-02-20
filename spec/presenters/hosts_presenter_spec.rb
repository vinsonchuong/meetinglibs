require 'spec_helper'

describe HostsPresenter do
  subject { HostsPresenter.new(hosts, user_authenticator) }

  let(:event) { Event.create!(name: 'Event', archived: false) }
  let(:hosts) { event.hosts }
  let!(:host1) { event.hosts.create!(user_attributes: {first_name: 'John', last_name: 'Doe', email: 'jd@example.com', cas_user: '111'}) }
  let!(:host2) { event.hosts.create!(user_attributes: {first_name: 'Alex', last_name: 'Langley', email: 'al@example.com', cas_user: '222'}) }

  context 'for administrators' do
    let(:user_authenticator) { mock(UserAuthenticator, administrator?: true) }

    it 'should present all the hosts of the event' do
      expect(subject.as_json).to eq([
        {id: host1.id, first_name: 'John', last_name: 'Doe', email: 'jd@example.com', cas_user: '111', token: nil},
        {id: host2.id, first_name: 'Alex', last_name: 'Langley', email: 'al@example.com', cas_user: '222', token: nil}
      ])
    end
  end

  context 'for users' do
    let(:user_authenticator) { mock(UserAuthenticator, administrator?: false) }

    it 'should present only the names of the hosts of the event' do
      expect(subject.as_json).to eq([
        {id: host1.id, first_name: 'John', last_name: 'Doe'},
        {id: host2.id, first_name: 'Alex', last_name: 'Langley'}
      ])
    end
  end
end
