require 'spec_helper'

describe VisitorInput do
  subject { VisitorInput.new(params, user_authenticator) }
  let(:user_authenticator) { mock(UserAuthenticator) }
  let(:valid_params) { {first_name: 'John', last_name: 'Doe', email: 'jd@example.com', cas_user: '111'} }

  context 'when the user is an administrator' do
    before { user_authenticator.stub(:administrator?).and_return(true) }

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

    context 'when a user already exists with the given cas_user' do
      let(:params) { valid_params }
      let!(:user) { User.create!(cas_user: '111') }
      its(:attributes) { should eq(user_id: user.id, user_attributes: {id: user.id, first_name: 'John', last_name: 'Doe', email: 'jd@example.com', cas_user: '111', token: nil}) }
    end

    context 'when updating' do
      let(:params) { valid_params.merge(id: host.id) }
      let!(:host) { Visitor.create(user: user) }
      let!(:user) { User.create!(cas_user: '111') }
      its(:attributes) { should eq(user_attributes: {id: user.id, first_name: 'John', last_name: 'Doe', email: 'jd@example.com', cas_user: '111', token: nil}) }
    end
  end

  context 'when the user is not an administrator' do
    let(:user) { User.create(first_name: 'John', last_name: 'Doe') }
    let(:user_authenticator) { mock(UserAuthenticator, administrator?: false, user: user) }

    context 'with valid parameters' do
      let(:params) { valid_params }
      it { should be_valid }
      its(:first_name) { should eq('John') }
      its(:last_name) { should eq('Doe') }
      its(:email) { should eq('jd@example.com') }
      its(:cas_user) { should eq('111') }
      its(:attributes) { should eq(user_id: user.id, user_attributes: {id: user.id, first_name: 'John', last_name: 'Doe', email: 'jd@example.com', cas_user: '111', token: nil}) }
    end
  end
end

