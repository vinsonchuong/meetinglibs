require 'spec_helper'

describe VisitorsPresenter do
  subject { VisitorsPresenter.new(visitors, user_authenticator) }

  let(:event) { Event.create!(name: 'Event', archived: false) }
  let(:visitors) { [visitor1, visitor2] }
  let!(:visitor1) { event.visitors.create!(user_attributes: {first_name: 'John', last_name: 'Doe', email: 'jd@example.com', cas_user: '111'}) }
  let!(:visitor2) { event.visitors.create!(user_attributes: {first_name: 'Alex', last_name: 'Langley', email: 'al@example.com', cas_user: '222'}) }

  context 'for administrators' do
    let(:user_authenticator) { mock(UserAuthenticator, administrator?: true) }

    it 'should present all the visitors of the event' do
      expect(subject.as_json).to eq([
        {id: visitor1.id, first_name: 'John', last_name: 'Doe', email: 'jd@example.com', cas_user: '111', token: nil},
        {id: visitor2.id, first_name: 'Alex', last_name: 'Langley', email: 'al@example.com', cas_user: '222', token: nil}
      ])
    end
  end

  context 'for users' do
    let(:user_authenticator) { mock(UserAuthenticator, administrator?: false) }

    it 'should present only the names of the visitors of the event' do
      expect(subject.as_json).to eq([
        {id: visitor1.id, first_name: 'John', last_name: 'Doe'},
        {id: visitor2.id, first_name: 'Alex', last_name: 'Langley'}
      ])
    end
  end
end
