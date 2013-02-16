require 'spec_helper'

describe Event do
  subject { Event.create(name: 'Event Name', archived: false) }
  its(:name) { should eq('Event Name') }
  it { should_not be_archived }

  describe '.scoped' do
    before do
      Event.create(name: 'Event1', archived: false)
      Event.create(name: 'Event2', archived: true)
      Event.create(name: 'Event3', archived: false)
    end
    subject { Event.scoped }

    it 'should be a collection of Events with the correct attributes' do
      expect(subject.pluck(:name)).to eq(%w[Event1 Event2 Event3])
      expect(subject.pluck(:archived)).to eq([false, true, false])
    end
  end
end
