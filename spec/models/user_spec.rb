require 'spec_helper'

describe User do
  subject do
    User.create!(
      first_name: 'John', last_name: 'Doe', email: 'jdoe@example.com',
      administrator: true,
      cas_user: 'cas_user', token: 'token'
    )
  end

  its(:first_name) { should eq('John') }
  its(:last_name) { should eq('Doe') }
  its(:email) { should eq('jdoe@example.com') }
  it { should be_administrator }
  its(:cas_user) { should eq('cas_user') }
  its(:token) { should eq('token') }
end
