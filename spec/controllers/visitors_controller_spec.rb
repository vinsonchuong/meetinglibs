require 'spec_helper'

describe VisitorsController do
  let(:event) { Event.create!(name: 'Event', archived: false) }

  describe '#index' do
    def call_action
      get :index, event_id: event.id, format: :json
    end

    it_should_behave_like 'an authenticated action'

    context 'when authenticated' do
      before { UserAuthenticator.any_instance.stub(:authenticated?).and_return(true) }
      let!(:visitor1) { event.visitors.create!(user_attributes: {first_name: 'John', last_name: 'Doe', email: 'john@example.com', token: '111'}) }
      let!(:visitor2) { event.visitors.create!(user_attributes: {first_name: 'Jane', last_name: 'Doe', email: 'jane@example.com', token: '222'}) }

      describe 'as an administrator' do
        before { UserAuthenticator.any_instance.stub(:administrator?).and_return(true) }

        it 'should return all the visitors for the event' do
          call_action
          expect(JSON.parse(response.body)).to include(
            {id: visitor1.id, first_name: 'John', last_name: 'Doe', email: 'john@example.com', cas_user: nil, token: '111'}.stringify_keys,
            {id: visitor2.id, first_name: 'Jane', last_name: 'Doe', email: 'jane@example.com', cas_user: nil, token: '222'}.stringify_keys
          )
        end
      end

      describe 'as a user' do
        before { UserAuthenticator.any_instance.stub(:administrator?).and_return(false) }

        it 'should return only the names of the visitors for the event' do
          call_action
          expect(JSON.parse(response.body)).to include(
            {id: visitor1.id, first_name: 'John', last_name: 'Doe'}.stringify_keys,
            {id: visitor2.id, first_name: 'Jane', last_name: 'Doe'}.stringify_keys
          )
        end
      end
    end
  end

  describe '#create' do
    def call_action
      post :create, event_id: event.id, first_name: 'John', last_name: 'Doe', email: 'john@example.com', token: '111', format: :json
    end

    it_should_behave_like 'an authenticated action'

    context 'when authenticated as an administrator' do
      before do
        UserAuthenticator.any_instance.stub(:authenticated?).and_return(true)
        UserAuthenticator.any_instance.stub(:administrator?).and_return(true)
      end

      context 'when given valid input' do
        before { VisitorInput.any_instance.stub(:valid?).and_return(true) }

        it 'should create the model' do
          call_action
          expect(event.visitors.where(user_id: User.where(first_name: 'John').first)).not_to be_empty
        end

        context 'when a user with the given token already exists' do
          let!(:user) { User.create!(token: '111') }

          it 'should create the model and associate it with the user' do
            call_action
            expect(event.visitors.where(user_id: user.id)).not_to be_empty
          end
        end

        it 'should respond with 201 Created' do
          call_action
          expect(response.code).to eq('201')
        end

        it 'should return the created model' do
          call_action
          expect(JSON.parse(response.body).symbolize_keys).to include(
            :id,
            first_name: 'John', last_name: 'Doe', email: 'john@example.com',
            cas_user: nil, token: '111'
          )
        end
      end

      context 'when given invalid input' do
        before { VisitorInput.any_instance.stub(:valid?).and_return(false) }

        it 'should respond with 400 Bad Request' do
          call_action
          expect(response.code).to eq('400')
        end
      end
    end

    context 'when authenticated as a user who is not participating in the event' do
      let!(:user) { User.create(first_name: 'John', last_name: 'Doe') }
      before do
        UserAuthenticator.any_instance.stub(:authenticated?).and_return(true)
        UserAuthenticator.any_instance.stub(:user).and_return(user)
        UserAuthenticator.any_instance.stub(:administrator?).and_return(false)
        UserAuthenticator.any_instance.stub(:participant?).and_return(false)
      end

      context 'when given valid input' do
        before { VisitorInput.any_instance.stub(:valid?).and_return(true) }

        it 'should create the model for the authenticated user' do
          call_action
          expect(event.visitors.where(user_id: user.id)).not_to be_empty
        end

        it 'should respond with 201 Created' do
          call_action
          expect(response.code).to eq('201')
        end

        it 'should return the created model' do
          call_action
          expect(JSON.parse(response.body).symbolize_keys).to include(
            :id,
            first_name: 'John', last_name: 'Doe', email: 'john@example.com',
            cas_user: nil, token: '111'
          )
        end
      end
    end
  end

  describe '#update' do
    def call_action
      put :update, event_id: event.id, id: visitor.id, email: 'new@example.com', format: :json
    end

    let!(:visitor) { event.visitors.create!(user_attributes: {first_name: 'John', last_name: 'Doe', email: 'jd@example.com'}) }
    let!(:user) { visitor.user }

    it_should_behave_like 'an authenticated action'

    context 'when authenticated as an administrator' do
      before do
        UserAuthenticator.any_instance.stub(:authenticated?).and_return(true)
        UserAuthenticator.any_instance.stub(:administrator?).and_return(true)
      end

      context 'when given valid input' do
        before { VisitorInput.any_instance.stub(:valid?).and_return(true) }

        it 'should update the model' do
          call_action
          expect(visitor.reload.user.email).to eq('new@example.com')
        end

        it 'should not create a new associated user' do
          expect(visitor.reload.user).to eq(user)
        end

        it 'should respond with 204 No Content' do
          call_action
          expect(response.code).to eq('204')
        end
      end

      context 'when given invalid input' do
        before { VisitorInput.any_instance.stub(:valid?).and_return(false) }

        it 'should respond with 400 Bad Request' do
          call_action
          expect(response.code).to eq('400')
        end
      end
    end

    context 'when authenticated as the host' do
      before do
        UserAuthenticator.any_instance.stub(:authenticated?).and_return(true)
        UserAuthenticator.any_instance.stub(:administrator?).and_return(false)
        UserAuthenticator.any_instance.stub(:visitor?).and_return(true)
        UserAuthenticator.any_instance.stub(:visitor).and_return(visitor)
      end

      context 'when given valid input' do
        before { VisitorInput.any_instance.stub(:valid?).and_return(true) }

        it 'should update the model' do
          call_action
          expect(visitor.reload.user.email).to eq('new@example.com')
        end

        it 'should not create a new associated user' do
          call_action
          expect(visitor.reload.user).to eq(user)
        end

        it 'should respond with 204 No Content' do
          call_action
          expect(response.code).to eq('204')
        end
      end
    end
  end

  describe '#destroy' do
    def call_action
      delete :destroy, event_id: event.id, id: visitor.id, format: :json
    end

    let!(:visitor) { event.visitors.create!(user_attributes: {first_name: 'John', last_name: 'Doe', email: 'jd@example.com'}) }

    it_should_behave_like 'an authenticated action'
    it_should_behave_like 'an administrator action'

    context 'when authenticated as an administrator' do
      before do
        UserAuthenticator.any_instance.stub(:authenticated?).and_return(true)
        UserAuthenticator.any_instance.stub(:administrator?).and_return(true)
      end

      it 'should destroy the event' do
        call_action
        expect(event.visitors.where(user_id: User.where(first_name: 'John'))).to be_empty
      end
    end
  end
end
