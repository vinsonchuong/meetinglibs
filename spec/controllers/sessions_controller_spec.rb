require 'spec_helper'

describe SessionsController do
  describe '#new' do
    it 'should render the "new" template' do
      get :new
      expect(response).to render_template('new')
    end
  end

  describe '#calnet' do
    context 'when not authenticated' do
      it 'redirects to CalNet Authentication' do
        get :calnet
        expect(response).to redirect_to('https://auth.berkeley.edu/cas/login?service=' + CGI.escape('http://test.host/session/calnet'))
      end
    end

    context 'when authenticated' do
      before do
        @user = User.create(cas_user: 'cas_user_id')
        RubyCAS::Filter.fake('cas_user_id')
      end

      it 'should store the CAS user id in the session' do
        get :calnet
        expect(session[:cas_user]).to eq('cas_user_id')
      end

      it 'should store the associated user id in the session' do
        get :calnet
        expect(session[:user_id]).to eq(@user.id)
      end

      it 'should redirect to #show' do
        get :calnet
        expect(response).to redirect_to(action: :show)
      end
    end
  end

  describe '#create' do
    context 'when a user with the given token exists' do
      before do
        @user = User.create(token: 'login_token')
      end

      it 'should store the associated user id in the session' do
        post :create, token: 'login_token'
        expect(session[:user_id]).to eq(@user.id)
      end

      it 'should redirect to #show' do
        post :create, token: 'login_token'
        expect(response).to redirect_to(action: :show)
      end
    end

    context 'when no user with the given token exists' do
      it 'should assign the token to @token' do
        post :create, token: 'login_token'
        expect(assigns[:token]).to eq('login_token')
      end

      it 'should flash an error message' do
        post :create, token: 'login_token'
        expect(flash[:error]).to eq('invalid token')
      end

      it 'should render the "new" template' do
        post :create, token: 'login_token'
        expect(response).to render_template('new')
      end
    end
  end

  describe '#show' do
    context 'when authenticated' do
      before do
        @user = User.create
        session[:user_id] = @user.id
      end

      it 'should render the "show" template' do
        get :show
        expect(response).to render_template('show')
      end
    end

    context 'when not authenticated' do
      it 'should redirect to #new' do
        get :show
        expect(response).to redirect_to(action: :new)
      end
    end
  end

  describe '#destroy' do
    context 'when the user is authenticated' do
      before do
        @user = User.create
        session[:user_id] = @user.id
      end

      it 'should clear the session' do
        delete :destroy
        expect(session[:user_id]).to be_blank
      end

      context 'via CalNet' do
        before do
          @user.update_attributes(cas_user: 'cas_user_id')
          session[:cas_user] = @user.cas_user
        end

        it 'should redirect to CalNet logout' do
          delete :destroy
          expect(response).to redirect_to('https://auth.berkeley.edu/cas/logout?service')
        end
      end
    end

    it 'should redirect to #new' do
      delete :destroy
      expect(response).to redirect_to(action: :new)
    end
  end
end
