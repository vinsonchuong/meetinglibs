require 'spec_helper'

describe HostPresenter do
  subject { HostPresenter.new(host) }
  let(:host) { event.hosts.create!(user_attributes: {first_name: 'John', last_name: 'Doe', email: 'jd@example.com', cas_user: '111'}) }
  let(:event) { Event.create!(name: 'Event', archived: false) }

  it 'should present the host' do
    expect(subject.as_json).to eq(id: host.id, first_name: 'John', last_name: 'Doe', email: 'jd@example.com', cas_user: '111', token: nil)
  end
end
