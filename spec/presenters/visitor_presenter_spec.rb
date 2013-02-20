require 'spec_helper'

describe VisitorPresenter do
  subject { VisitorPresenter.new(visitor) }
  let(:visitor) { event.visitors.create!(user_attributes: {first_name: 'John', last_name: 'Doe', email: 'jd@example.com', cas_user: '111'}) }
  let(:event) { Event.create!(name: 'Event', archived: false) }

  it 'should present the visitor' do
    expect(subject.as_json).to eq(id: visitor.id, first_name: 'John', last_name: 'Doe', email: 'jd@example.com', cas_user: '111', token: nil)
  end
end
