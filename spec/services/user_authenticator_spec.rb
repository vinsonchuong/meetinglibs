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

    context 'when provided a cas_user it cannot find a user for' do
      before { subject.authenticate!(cas_user: 'cas_user') }
      it { should be_authenticated }
      its('user.cas_user') { should eq('cas_user') }
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

    context 'when scoped to an event' do
      subject { UserAuthenticator.new(session, event) }
      let(:event) { Event.create(name: 'Event') }
      let!(:user) { User.create(cas_user: 'cas_user') }
      before { subject.authenticate!(cas_user: 'cas_user') }

      context 'when the user is not participating in the event' do
        it { should be_authenticated }
        it { should_not be_participant }
        it { should_not be_host }
        it { should_not be_visitor }
      end

      context 'when the user is a host for the event' do
        let!(:host) { event.hosts.create(user: user) }

        it { should be_authenticated }
        it { should be_participant }
        it { should be_host }
        it { should_not be_visitor }
      end

      context 'when the user is a visitor for the event' do
        let!(:host) { event.visitors.create(user: user) }

        it { should be_authenticated }
        it { should be_participant }
        it { should_not be_host }
        it { should be_visitor }
      end
    end
  end
end
