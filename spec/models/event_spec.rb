require 'spec_helper'

describe Event do
  subject { Event.create!(attributes) }
  let(:attributes) { {name: 'Event Name', archived: false} }
  its(:name) { should eq('Event Name') }
  it { should_not be_archived }

  context 'when creating associated records' do
    let!(:host1) { subject.hosts.create!(user: User.create(first_name: 'John')) }
    let!(:host2) { subject.hosts.create!(user: User.create(first_name: 'Andy')) }
    let!(:host3) { subject.hosts.create!(user: User.create(first_name: 'Bob')) }

    let!(:visitor1) { subject.visitors.create!(user: User.create(first_name: 'John')) }
    let!(:visitor2) { subject.visitors.create!(user: User.create(first_name: 'Andy')) }
    let!(:visitor3) { subject.visitors.create!(user: User.create(first_name: 'Bob')) }

    its(:hosts) { should include(host1, host2, host3) }
    its(:visitors) { should include(visitor1, visitor2, visitor3) }
  end

  context 'when given host and visitor attributes' do
    let(:attributes) do
      {
        name: 'Event Name', archived: false,
        hosts_attributes: [
          {user_attributes: {first_name: 'John', last_name: 'Doe', email: 'jdoe@example.com', cas_user: '123456'}},
          {user_attributes: {first_name: 'Andrew', last_name: 'Park', email: 'apark@example.com', token: 'apark@example.com'}},
          {user_attributes: {first_name: 'Sara', last_name: 'Stone', email: '', cas_user: '', token: ''}}
        ],
        visitors_attributes: [
          {user_attributes: {first_name: 'Jane', last_name: 'Doe', email: 'jane@example.com'}},
        ]
      }
    end

    it 'should create hosts' do
      expect(subject.hosts.map(&:user).map(&:first_name).sort).to eq(%w[Andrew John Sara])
    end

    it 'should create visitors' do
      expect(subject.visitors.map(&:user).map(&:first_name).sort).to eq(%w[Jane])
    end
  end

  describe '.ordered' do
    before do
      Event.create(name: 'Event1', archived: false)
      Event.create(name: 'Event2', archived: true)
      Event.create(name: 'Event3', archived: false)
    end
    subject { Event.ordered }

    it 'should be a collection of Events with the correct attributes and order' do
      expect(subject.pluck(:name)).to eq(%w[Event3 Event1 Event2])
      expect(subject.pluck(:archived)).to eq([false, false, true])
    end
  end
end
