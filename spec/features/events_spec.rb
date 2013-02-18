require 'spec_helper'

feature 'viewing a listing of events' do
  background do
    Event.create(name: 'Event 1', archived: true)
    Event.create(name: 'Event 2')
    Event.create(name: 'Event 3')
  end

  scenario 'as an administrator' do
    sign_in with: {administrator: true}, via: :calnet

    expect(find('.event_list .event:nth-child(1) .name')).to have_text('Event 1')
    expect(find('.event_list .event:nth-child(2) .name')).to have_text('Event 2')
    expect(find('.event_list .event:nth-child(3) .name')).to have_text('Event 3')
  end

  scenario 'as a normal user' do
    sign_in with: {administrator: false}, via: :calnet
    expect(find('.event_list .event:nth-child(1) .name')).to have_text('Event 2')
    expect(find('.event_list .event:nth-child(2) .name')).to have_text('Event 3')

    expect(page).to have_no_text('Event 1')
  end
end

feature 'archiving an event' do
  background do
    Event.create(name: 'Event 1', archived: true)
    Event.create(name: 'Event 2')
    Event.create(name: 'Event 3')
  end

  scenario 'as an administrator' do
    sign_in with: {administrator: true}, via: :calnet
    within('.event_list .event:nth-child(2)') { click_link 'Archive' }
    within('.confirmation') do
      expect(find('.message')).to have_text('Do you want to continue?')
      click_link 'Archive Event'
    end
    expect(find('.event_list .event:nth-child(2)')['class']).to include('archived')
  end

  scenario 'as a user' do
    sign_in with: {administrator: false}, via: :calnet
    expect(page).to have_no_link('Archive')
  end
end
