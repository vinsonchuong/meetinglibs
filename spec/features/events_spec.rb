require 'spec_helper'

feature 'viewing a listing of events' do
  background do
    Event.create(name: 'Event 1', archived: true)
    Event.create(name: 'Event 2')
    Event.create(name: 'Event 3')
  end

  scenario 'as an administrator' do
    sign_in with: {administrator: true}, via: :calnet
    expect(page.find('.event:nth-child(1) .name')).to have_text('Event 1')
    expect(page.find('.event:nth-child(2) .name')).to have_text('Event 2')
    expect(page.find('.event:nth-child(3) .name')).to have_text('Event 3')
  end

  scenario 'as a normal user' do
    sign_in with: {administrator: false}, via: :calnet
    expect(page.find('.event:nth-child(1) .name')).to have_text('Event 2')
    expect(page.find('.event:nth-child(2) .name')).to have_text('Event 3')
  end
end
