require 'spec_helper'

describe EventPresenter do
  subject { EventPresenter.new(event) }
  let(:event) { Event.create(name: 'Event', archived: false) }

  it 'should present the event' do
    expect(subject.as_json).to eq(id: event.id, name: 'Event', archived: false)
  end
end
