require 'spec_helper'

describe Event do
  subject { Event.create!(name: 'Event Name', archived: false) }
  its(:name) { should eq('Event Name') }
  it { should_not be_archived }

  describe '#hosts' do
    let!(:host1) { subject.hosts.create!(user: User.create(first_name: 'John')) }
    let!(:host2) { subject.hosts.create!(user: User.create(first_name: 'Andy')) }
    let!(:host3) { subject.hosts.create!(user: User.create(first_name: 'Bob')) }

    its(:hosts) { should eq([host1, host2, host3]) }
  end

  describe '#visitors' do
    let!(:visitor1) { subject.visitors.create!(user: User.create(first_name: 'John')) }
    let!(:visitor2) { subject.visitors.create!(user: User.create(first_name: 'Andy')) }
    let!(:visitor3) { subject.visitors.create!(user: User.create(first_name: 'Bob')) }

    its(:visitors) { should eq([visitor1, visitor2, visitor3]) }
  end

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
