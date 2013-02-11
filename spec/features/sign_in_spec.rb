require 'spec_helper'

feature 'signing in through CalNet Authentication' do
  scenario 'providing valid credentials' do
    sign_in via: :calnet
    expect(current_path).to eq('/')
    expect(page).to have_content('MeetingLibs')
  end
end

feature 'signing in by providing an invitation token' do
  scenario 'providing a valid token' do
    sign_in via: :token
    expect(current_path).to eq('/')
    expect(page).to have_content('MeetingLibs')
  end

  scenario 'providing an invalid token' do
    sign_in via: :invalid_token
    expect(page).to have_content('invalid token')
  end
end
