require 'spec_helper'

feature 'taking the survey' do
  given!(:event) { Event.create(name: 'Event', archived: false) }

  scenario 'as a CalNet authenticated user who is not yet a participant' do
    sign_in with: {administrator: false}, via: :calnet
    within('.event_list .event:nth-child(1)') { click_link 'Update Survey Answers' }
    fill_in 'First Name', with: 'John'
    fill_in 'Last Name', with: 'Doe'
    fill_in 'Email', with: 'john.doe@example.com'
    click_link 'Save'

    within('.event_list .event:nth-child(1)') { click_link 'Update Survey Answers' }
    expect(find_field('First Name').value).to eq('John')
    expect(find_field('Last Name').value).to eq('Doe')
    expect(event.hosts.first.user.email).to eq('john.doe@example.com')
  end

  scenario 'as a token authenticated user who has been assigned as a visitor' do
    event.visitors.create!(user: User.create!(first_name: 'John', last_name: 'Doe', email: 'jd@example.com', token: 'jd@example.com'))
    visit '/'
    fill_in 'invitation token', with: 'jd@example.com'
    click_button 'Sign In'

    within('.event_list .event:nth-child(1)') { click_link 'Update Survey Answers' }
    fill_in 'Email', with: 'john.doe@example.com'
    click_link 'Save'

    within('.event_list .event:nth-child(1)') { click_link 'Update Survey Answers' }
    expect(find_field('First Name').value).to eq('John')
    expect(find_field('Last Name').value).to eq('Doe')
    expect(event.visitors.first.user.email).to eq('john.doe@example.com')
  end
end
