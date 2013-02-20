require 'spec_helper'

describe EventInput do
  subject { EventInput.new(params) }
  let(:valid_params) { {name: 'Event', archived: false} }

  context 'with valid parameters' do
    let(:params) { valid_params }
    it { should be_valid }
    its(:name) { should eq('Event') }
    its(:archived) { should be_false }
    its(:attributes) { should include(name: 'Event', archived: false) }
  end

  context 'without name' do
    let(:params) { valid_params.except(:name) }
    it { should_not be_valid }
  end

  context 'without "archived"' do
    let(:params) { valid_params.except(:archived) }
    it { should be_valid }
    its(:archived) { should be_false }
  end

  context 'when a hosts CSV is provided' do
    let(:params) do
      valid_params.merge(hosts: <<-CSV.strip_heredoc)
        First Name,Last Name,Email,CalNet UID,Login Token
        John,Doe,jdoe@example.com,123456,
        Andrew,Park,apark@example.com,,apark@example.com
        Sara,Stone,,,
      CSV
    end
    let(:expected_hosts_attributes) do
      [
        {user_attributes: {first_name: 'John', last_name: 'Doe', email: 'jdoe@example.com', cas_user: '123456', token: nil}},
        {user_attributes: {first_name: 'Andrew', last_name: 'Park', email: 'apark@example.com', cas_user: nil, token: 'apark@example.com'}},
        {user_attributes: {first_name: 'Sara', last_name: 'Stone', email: nil, cas_user: nil, token: nil}}
      ]
    end

    its(:hosts_attributes) { should eq(expected_hosts_attributes) }
    its(:attributes) { should include(hosts_attributes: expected_hosts_attributes) }
  end

  context 'when a visitors CSV is provided' do
    let(:params) do
      valid_params.merge(visitors: <<-CSV.strip_heredoc)
        First Name,Last Name,Email,CalNet UID,Login Token
        John,Doe,jdoe@example.com,123456,
        Andrew,Park,apark@example.com,,apark@example.com
        Sara,Stone,,,
      CSV
    end
    let(:expected_visitors_attributes) do
      [
        {user_attributes: {first_name: 'John', last_name: 'Doe', email: 'jdoe@example.com', cas_user: '123456', token: nil}},
        {user_attributes: {first_name: 'Andrew', last_name: 'Park', email: 'apark@example.com', cas_user: nil, token: 'apark@example.com'}},
        {user_attributes: {first_name: 'Sara', last_name: 'Stone', email: nil, cas_user: nil, token: nil}}
      ]
    end

    its(:visitors_attributes) { should eq(expected_visitors_attributes) }
    its(:attributes) { should include(visitors_attributes: expected_visitors_attributes) }
  end
end

