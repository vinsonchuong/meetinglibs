require 'spec_helper'

describe Visitor do
  subject { Visitor.create!(attributes) }
  let(:event) { Event.create!(name: 'Event', archived: false) }

  context 'when associated records already exist' do
    let(:attributes) { {event: event, user: user} }
    let(:user) { User.create(first_name: 'John', last_name: 'Doe', cas_user: 'UID') }

    its(:event) { should eq(event) }
    its(:user) { should eq(user) }
  end

  context 'when the associated user does not exist' do
    let(:attributes) { {event: event, user_attributes: user_attributes} }
    let(:user_attributes) { {first_name: 'John', last_name: 'Doe', email: 'jdoe@example.com', cas_user: '123456'} }

    its('user.first_name') { should eq('John') }
  end

  describe '.with_contact_info' do
    subject { Visitor.with_contact_info }
    before do
      Visitor.create!(event: event, user: User.create(first_name: 'John'))
      Visitor.create!(event: event, user: User.create(first_name: 'Andy'))
      Visitor.create!(event: event, user: User.create(first_name: 'Bob'))
    end

    it 'be a collection of hosts including the associated users' do
      expect(subject.map(&:user).map(&:first_name).sort).to eq(%w[Andy Bob John])
    end
  end
end
