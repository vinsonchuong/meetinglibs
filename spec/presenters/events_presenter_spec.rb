require 'spec_helper'

describe EventsPresenter do
  subject { EventsPresenter.new(events, user_authenticator) }

  let(:events) { [event1, event2, event3] }
  let!(:event1) { Event.create(name: 'Event 1', archived: true) }
  let!(:event2) { Event.create(name: 'Event 2', archived: false) }
  let!(:event3) { Event.create(name: 'Event 3') }

  context 'for administrators' do
    let(:user_authenticator) { mock(UserAuthenticator, administrator?: true) }

    it 'should present all the events' do
      expect(subject.as_json).to eq([
        {id: event1.id, name: 'Event 1', archived: true},
        {id: event2.id, name: 'Event 2', archived: false},
        {id: event3.id, name: 'Event 3', archived: false}
      ])
    end
  end

  context 'for users' do
    let(:user_authenticator) { mock(UserAuthenticator, administrator?: false) }

    it 'should present only unarchived events' do
      expect(subject.as_json).to eq([
        {id: event2.id, name: 'Event 2'},
        {id: event3.id, name: 'Event 3'}
      ])
    end
  end
end
