require 'spec_helper'

describe EventsPresenter do
  subject { EventsPresenter.new(events, user_authenticator) }
  let!(:user) { User.create(first_name: 'John', last_name: 'Doe')}

  let(:events) { Event.ordered }
  let!(:event1) { Event.create(name: 'Event 1', archived: true) }
  let!(:event2) { Event.create(name: 'Event 2', archived: false) }
  let!(:event3) { Event.create(name: 'Event 3', archived: false) }

  context 'for administrators' do
    let(:user_authenticator) { mock(UserAuthenticator, user: user, administrator?: true) }

    it 'should present all the events' do
      expect(subject.as_json).to eq([
        {id: event3.id, name: 'Event 3', archived: false, host_id: nil, visitor_id: nil},
        {id: event2.id, name: 'Event 2', archived: false, host_id: nil, visitor_id: nil},
        {id: event1.id, name: 'Event 1', archived: true, host_id: nil, visitor_id: nil}
      ])
    end
  end

  context 'for users' do
    let(:user_authenticator) { mock(UserAuthenticator, user: user, administrator?: false) }

    it 'should present only unarchived events' do
      expect(subject.as_json).to eq([
        {id: event3.id, name: 'Event 3', host_id: nil, visitor_id: nil},
        {id: event2.id, name: 'Event 2', host_id: nil, visitor_id: nil}
      ])
    end

    context 'when the user is a host for one of these events' do
      let!(:host) { event2.hosts.create(user: user) }

      it 'should include the host id' do
        expect(subject.as_json).to eq([
          {id: event3.id, name: 'Event 3', host_id: nil, visitor_id: nil},
          {id: event2.id, name: 'Event 2', host_id: host.id, visitor_id: nil}
        ])
      end
    end
  end
end
