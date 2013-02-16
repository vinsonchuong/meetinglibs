require 'spec_helper'

describe EventsController do
  describe '#index' do
    context 'when authenticated' do
      before do
        UserAuthenticator.any_instance.stub(:authenticated?).and_return(true)
      end

      let!(:event1) { Event.create!(name: 'Event 1', archived: true) }
      let!(:event2) { Event.create!(name: 'Event 2') }
      let!(:event3) { Event.create!(name: 'Event 3') }

      describe 'as an administrator' do
        before do
          UserAuthenticator.any_instance.stub(:administrator?).and_return(true)
        end

        it 'should return all events' do
          get :index
          expect(response.body).to eq([
            {id: event1.id, name: 'Event 1', archived: true},
            {id: event2.id, name: 'Event 2', archived: false},
            {id: event3.id, name: 'Event 3', archived: false}
          ].to_json)
        end
      end

      describe 'as a user' do
        before do
          UserAuthenticator.any_instance.stub(:administrator?).and_return(false)
        end

        it 'should return only unarchived events' do
          get :index
          expect(response.body).to eq([
            {id: event2.id, name: 'Event 2'},
            {id: event3.id, name: 'Event 3'}
          ].to_json)
        end
      end
    end

    context 'when not authenticated' do
      before do
        UserAuthenticator.any_instance.stub(:authenticated?).and_return(false)
      end

      it 'should respond with 401 Unauthorized' do
        get :index
        expect(response.code).to eq('401')
      end
    end
  end
end
