require 'spec_helper'

feature 'viewing a list of hosts' do
  background do
    event = Event.create(name: 'Event', archived: false)
    event.hosts.create(user_attributes: {first_name: 'John', last_name: 'Doe', email: 'johndoe@example.com'})
    event.hosts.create(user_attributes: {first_name: 'Jane', last_name: 'Doe', email: 'janedoe@example.com'})
  end

  scenario 'as an administrator' do
    sign_in with: {administrator: true}, via: :calnet
    within('.event_list .event:nth-child(1)') { click_link 'Manage Hosts' }

    expect(find('.host_list .host:nth-child(1) .name')).to have_text('Jane Doe')
    expect(find('.host_list .host:nth-child(2) .name')).to have_text('John Doe')
  end
end

feature 'adding a host' do
  background { Event.create(name: 'Event', archived: false) }

  scenario 'as an administrator' do
    sign_in with: {administrator: true}, via: :calnet
    within('.event_list .event:nth-child(1)') { click_link 'Manage Hosts' }
    click_link 'Add Host'
    fill_in 'First Name', with: 'Chase'
    fill_in 'Last Name', with: 'Chen'
    fill_in 'Email', with: 'chase.chen@example.com'
    fill_in 'Login Token', with: 'chase.chen@example.com'
    click_link 'Add Host'

    expect(find('.host_list .host:nth-child(1) .name')).to have_text('Chase Chen')
  end
end

feature 'updating a host' do
  background do
    event = Event.create(name: 'Event', archived: false)
    event.hosts.create(user_attributes: {first_name: 'John', last_name: 'Doe', email: 'johndoe@example.com'})
  end

  scenario 'as an administrator' do
    sign_in with: {administrator: true}, via: :calnet
    within('.event_list .event:nth-child(1)') { click_link 'Manage Hosts' }
    within('.host_list .host:nth-child(1)') { click_link 'Edit' }
    fill_in 'First Name', with: 'Chase'
    click_link 'Update Host'
    expect(find('.host_list .host:nth-child(1) .name')).to have_text('Chase Doe')
  end
end

feature 'removing a host' do
  background do
    event = Event.create(name: 'Event', archived: false)
    event.hosts.create(user_attributes: {first_name: 'John', last_name: 'Doe', email: 'johndoe@example.com'})
  end

  scenario 'as an administrator' do
    sign_in with: {administrator: true}, via: :calnet
    within('.event_list .event:nth-child(1)') { click_link 'Manage Hosts' }
    within('.host_list .host:nth-child(1)') { click_link 'Remove' }
    within('.confirmation') do
      expect(find('.message')).to have_text('Do you want to continue?')
      click_link 'Remove Host'
    end
    expect(find('.host_list')).to have_no_text('John Doe')
  end
end
