require 'spec_helper'

describe EventsController do
  describe '#index' do
    def call_action
      get :index, format: :json
    end

    it_should_behave_like 'an authenticated action'

    context 'when authenticated' do
      before { UserAuthenticator.any_instance.stub(:authenticated?).and_return(true) }
      let!(:event1) { Event.create!(name: 'Event 1', archived: true) }
      let!(:event2) { Event.create!(name: 'Event 2') }
      let!(:event3) { Event.create!(name: 'Event 3') }

      describe 'as an administrator' do
        before { UserAuthenticator.any_instance.stub(:administrator?).and_return(true) }

        it 'should return all events' do
          call_action
          expect(response.body).to eq([
            {id: event1.id, name: 'Event 1', archived: true},
            {id: event2.id, name: 'Event 2', archived: false},
            {id: event3.id, name: 'Event 3', archived: false}
          ].to_json)
        end
      end

      describe 'as a user' do
        before { UserAuthenticator.any_instance.stub(:administrator?).and_return(false) }

        it 'should return only unarchived events' do
          call_action
          expect(response.body).to eq([
            {id: event2.id, name: 'Event 2'},
            {id: event3.id, name: 'Event 3'}
          ].to_json)
        end
      end
    end
  end

  describe '#update' do
    def call_action
      put :update, id: event.id, name: 'New Name', format: :json
    end

    let!(:event) { Event.create!(name: 'Event', archived: true) }

    it_should_behave_like 'an authenticated action'
    it_should_behave_like 'an administrator action'

    context 'when authenticated as an administrator' do
      before do
        UserAuthenticator.any_instance.stub(:authenticated?).and_return(true)
        UserAuthenticator.any_instance.stub(:administrator?).and_return(true)
      end

      context 'when given valid input' do
        before { EventInput.any_instance.stub(:valid?).and_return(true) }

        it 'should update the model' do
          call_action
          expect(event.reload.name).to eq('New Name')
        end

        it 'should respond with 204 No Content' do
          call_action
          expect(response.code).to eq('204')
        end
      end

      context 'when given invalid input' do
        before { EventInput.any_instance.stub(:valid?).and_return(false) }

        it 'should respond with 400 Bad Request' do
          call_action
          expect(response.code).to eq('400')
        end
      end
    end
  end
end
