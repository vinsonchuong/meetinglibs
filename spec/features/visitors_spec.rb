require 'spec_helper'

feature 'viewing a list of visitors' do
  background do
    event = Event.create(name: 'Event', archived: false)
    event.visitors.create(user_attributes: {first_name: 'John', last_name: 'Doe', email: 'johndoe@example.com'})
    event.visitors.create(user_attributes: {first_name: 'Jane', last_name: 'Doe', email: 'janedoe@example.com'})
    event.visitors.create(user_attributes: {first_name: 'Jack', last_name: 'Lane', email: 'jack@example.com'})
  end

  scenario 'as an administrator' do
    sign_in with: {administrator: true}, via: :calnet
    within('.event_list .event:nth-child(1)') { click_link 'Manage Visitors' }

    expect(find('.visitor_list .visitor:nth-child(1) .name')).to have_text('Jane Doe')
    expect(find('.visitor_list .visitor:nth-child(2) .name')).to have_text('John Doe')
    expect(find('.visitor_list .visitor:nth-child(3) .name')).to have_text('Jack Lane')
  end
end

feature 'adding a visitor' do
  background { Event.create(name: 'Event', archived: false) }

  scenario 'as an administrator' do
    sign_in with: {administrator: true}, via: :calnet
    within('.event_list .event:nth-child(1)') { click_link 'Manage Visitors' }
    click_link 'Add Visitor'
    fill_in 'First Name', with: 'Chase'
    fill_in 'Last Name', with: 'Chen'
    fill_in 'Email', with: 'chase.chen@example.com'
    fill_in 'Login Token', with: 'chase.chen@example.com'
    click_link 'Add Visitor'

    expect(find('.visitor_list .visitor:nth-child(1) .name')).to have_text('Chase Chen')
  end
end

feature 'updating a visitor' do
  background do
    event = Event.create(name: 'Event', archived: false)
    event.visitors.create(user_attributes: {first_name: 'John', last_name: 'Doe', email: 'johndoe@example.com'})
  end

  scenario 'as an administrator' do
    sign_in with: {administrator: true}, via: :calnet
    within('.event_list .event:nth-child(1)') { click_link 'Manage Visitors' }
    within('.visitor_list .visitor:nth-child(1)') { click_link 'Edit' }
    fill_in 'First Name', with: 'Chase'
    click_link 'Update Visitor'
    expect(find('.visitor_list .visitor:nth-child(1) .name')).to have_text('Chase Doe')
  end
end

feature 'removing a visitor' do
  background do
    event = Event.create(name: 'Event', archived: false)
    event.visitors.create(user_attributes: {first_name: 'John', last_name: 'Doe', email: 'johndoe@example.com'})
  end

  scenario 'as an administrator' do
    sign_in with: {administrator: true}, via: :calnet
    within('.event_list .event:nth-child(1)') { click_link 'Manage Visitors' }
    within('.visitor_list .visitor:nth-child(1)') { click_link 'Remove' }
    within('.confirmation') do
      expect(find('.message')).to have_text('Do you want to continue?')
      click_link 'Remove Visitor'
    end
    expect(find('.visitor_list')).to have_no_text('John Doe')
  end
end
