require 'spec_helper'

feature 'signing in through CalNet Authentication' do
  given(:cas_user) { ENV['CAS_USER'] }
  given(:calnet_id) { ENV['CALNET_ID'] }
  given(:calnet_passphrase) { ENV['CALNET_PASSPHRASE'] }

  background do
    unless [cas_user, calnet_id, calnet_passphrase].all?(&:present?)
      pending 'CalNet credentials not specified'
    end

    User.create!(cas_user: cas_user)
  end

  scenario 'providing valid credentials' do
    visit '/'
    click_link 'CalNet Authentication'
    fill_in 'CalNet ID', with: calnet_id
    fill_in 'Passphrase', with: calnet_passphrase
    click_button 'Sign In'
    expect(current_path).to eq('/')
    expect(page).to have_content('MeetingLibs')
  end
end

feature 'signing in by providing an invitation token' do
  given(:token) { 'token' }
  given(:invalid_token) { 'invalid' }

  background do
    User.create!(token: token)
  end

  scenario 'providing a valid token' do
    visit '/'
    fill_in 'invitation token', with: token
    click_button 'Sign In'
    expect(current_path).to eq('/')
    expect(page).to have_content('MeetingLibs')
  end

  scenario 'providing an invalid token' do
    visit '/'
    fill_in 'invitation token', with: invalid_token
    click_button 'Sign In'
    expect(page).to have_content('invalid token')
  end
end
