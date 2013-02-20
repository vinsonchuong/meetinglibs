require 'spec_helper'

describe HostInput do
  subject { HostInput.new(params) }
  let(:valid_params) { {first_name: 'John', last_name: 'Doe', email: 'jd@example.com', cas_user: '111'} }

  context 'with valid parameters' do
    let(:params) { valid_params }
    it { should be_valid }
    its(:first_name) { should eq('John') }
    its(:last_name) { should eq('Doe') }
    its(:email) { should eq('jd@example.com') }
    its(:cas_user) { should eq('111') }
    its(:attributes) { should eq(user_attributes: {first_name: 'John', last_name: 'Doe', email: 'jd@example.com', cas_user: '111', token: nil}) }
  end

  context 'without a first name' do
    let(:params) { valid_params.except(:first_name) }
    it { should_not be_valid }
  end

  context 'without a last name' do
    let(:params) { valid_params.except(:last_name) }
    it { should_not be_valid }
  end

  context 'without an email' do
    let(:params) { valid_params.except(:email) }
    it { should_not be_valid }
  end
end

