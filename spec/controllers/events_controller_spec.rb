require 'spec_helper'

describe EventsController do
  describe '#index' do
    def call_action
      get :index, format: :json
    end

    it_should_behave_like 'an authenticated action'

    context 'when authenticated' do
      let!(:user) { User.create!(first_name: 'John', last_name: 'Doe') }
      before do
        UserAuthenticator.any_instance.stub(:authenticated?).and_return(true)
        UserAuthenticator.any_instance.stub(:user).and_return(user)
      end
      let!(:event1) { Event.create!(name: 'Event 1', archived: true) }
      let!(:event2) { Event.create!(name: 'Event 2', archived: false) }
      let!(:event3) { Event.create!(name: 'Event 3', archived: false) }

      describe 'as an administrator' do
        before { UserAuthenticator.any_instance.stub(:administrator?).and_return(true) }

        it 'should return all events' do
          call_action
          expect(JSON.parse(response.body)).to include(
            {id: event1.id, name: 'Event 1', archived: true, host_id: nil, visitor_id: nil}.stringify_keys,
            {id: event2.id, name: 'Event 2', archived: false, host_id: nil, visitor_id: nil}.stringify_keys,
            {id: event3.id, name: 'Event 3', archived: false, host_id: nil, visitor_id: nil}.stringify_keys
          )
        end
      end

      describe 'as a user' do
        before { UserAuthenticator.any_instance.stub(:administrator?).and_return(false) }

        it 'should return only unarchived events' do
          call_action
          expect(JSON.parse(response.body)).to include(
            {id: event2.id, name: 'Event 2', host_id: nil, visitor_id: nil}.stringify_keys,
            {id: event3.id, name: 'Event 3', host_id: nil, visitor_id: nil}.stringify_keys
          )
        end
      end
    end
  end

  describe '#create' do
    def call_action
      post :create, name: 'New Name', archived: false, format: :json
    end

    it_should_behave_like 'an authenticated action'
    it_should_behave_like 'an administrator action'

    context 'when authenticated as an administrator' do
      before do
        UserAuthenticator.any_instance.stub(:authenticated?).and_return(true)
        UserAuthenticator.any_instance.stub(:administrator?).and_return(true)
      end

      context 'when given valid input' do
        before { EventInput.any_instance.stub(:valid?).and_return(true) }

        it 'should create the model' do
          call_action
          expect(Event.where(name: 'New Name')).not_to be_empty
        end

        it 'should respond with 201 Created' do
          call_action
          expect(response.code).to eq('201')
        end

        it 'should return the created model' do
          call_action
          json = JSON.parse(response.body).symbolize_keys
          expect(json).to include(:id, name: 'New Name', archived: false)
          expect(json.keys).to eq([:id, :name, :archived])
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

  describe '#destroy' do
    def call_action
      delete :destroy, id: event.id, format: :json
    end

    let!(:event) { Event.create!(name: 'Event', archived: true) }

    it_should_behave_like 'an authenticated action'
    it_should_behave_like 'an administrator action'

    context 'when authenticated as an administrator' do
      before do
        UserAuthenticator.any_instance.stub(:authenticated?).and_return(true)
        UserAuthenticator.any_instance.stub(:administrator?).and_return(true)
      end

      it 'should destroy the event' do
        call_action
        expect(Event.where(name: 'Event 1')).to be_empty
      end
    end
  end
end
