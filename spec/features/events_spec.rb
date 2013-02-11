require 'spec_helper'

feature 'viewing a listing of events' do
  background do
    Event.create(name: 'Event 1', archived: true)
    Event.create(name: 'Event 2')
    Event.create(name: 'Event 3')
  end

  scenario 'as an administrator' do
    pending
    sign_in with: {administrator: true}, via: :calnet
    expect(page.all('.event .name').map(&:text)).to eq(['Event 1', 'Event 2', 'Event 3'])
  end

  scenario 'as a normal user' do
    pending
    sign_in with: {administrator: false}, via: :calnet
    expect(page.all('.event .name').map(&:text)).to eq(['Event 2', 'Event 3'])
  end
end
