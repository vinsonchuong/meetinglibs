require 'spec_helper'

describe UserAuthenticator do
  subject { UserAuthenticator.new(session) }
  let(:session) { {} }

  it { should_not be_authenticated }

  describe '#authenticate!' do
    context 'when provided a valid cas_user' do
      let!(:user) { User.create(cas_user: 'cas_user') }
      before { subject.authenticate!(cas_user: 'cas_user') }

      it { should be_authenticated }
      its(:user) { should eq(user) }

      it 'should stay authenticated for the duration of the session' do
        new_authenticator = UserAuthenticator.new(session)
        expect(new_authenticator).to be_authenticated
        expect(new_authenticator.user).to eq(user)
      end
    end

    context 'when provided a valid token' do
      let!(:user) { User.create(token: 'token') }
      before { subject.authenticate!(token: 'token') }

      it { should be_authenticated }
      its(:user) { should eq(user) }
    end

    context 'when provided administrator credentials' do
      let!(:user) { User.create(cas_user: 'cas_user', administrator: true) }
      before { subject.authenticate!(cas_user: 'cas_user') }

      it { should be_administrator }
    end

    context 'when provided invalid credentials' do
      before { subject.authenticate!(token: 'invalid') }

      it { should_not be_authenticated }
      its(:user) { should_not be_present }
    end
  end
end
