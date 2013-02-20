require 'spec_helper'

describe SessionsController do
  describe '#new' do
    it 'should render the "new" template' do
      get :new
      expect(response).to render_template('new')
    end
  end

  describe '#calnet' do
    context 'when not yet authenticated via CalNet Authentication' do
      it 'redirects to CalNet Authentication' do
        get :calnet
        expect(response).to redirect_to('https://auth-test.berkeley.edu/cas/login?service=' + CGI.escape('http://test.host/session/calnet'))
      end
    end

    context 'when authenticated via CalNet Authentication' do
      before do
        @user = User.create(cas_user: 'cas_user')
        RubyCAS::Filter.fake('cas_user')
      end

      context 'when successfully authenticated locally' do
        before do
          UserAuthenticator.any_instance
          .stub(:authenticated!)
          .with(cas_user: 'cas_user')
          .and_return(true)
        end

        it 'should redirect to #show' do
          get :calnet
          expect(response).to redirect_to(action: :show)
        end
      end
    end
  end

  describe '#create' do
    context 'when successfully authenticated' do
      before do
        UserAuthenticator.any_instance
          .stub(:authenticate!)
          .with(token: 'token')
          .and_return(true)
      end

      it 'should redirect to #show' do
        post :create, token: 'token'
        expect(response).to redirect_to(action: :show)
      end
    end

    context 'when not successfully authenticated' do
      before do
        UserAuthenticator.any_instance
          .stub(:authenticate!)
          .with(token: 'token')
          .and_return(false)
      end

      it 'should assign the token to @token' do
        post :create, token: 'token'
        expect(assigns[:token]).to eq('token')
      end

      it 'should flash an error message' do
        post :create, token: 'token'
        expect(flash[:error]).to eq('invalid token')
      end

      it 'should render the "new" template' do
        post :create, token: 'token'
        expect(response).to render_template('new')
      end
    end
  end

  describe '#show' do
    context 'when authenticated' do
      before do
        UserAuthenticator.any_instance.stub(:authenticated?).and_return(true)
        UserAuthenticator.any_instance.stub(:administrator?).and_return(true)
      end

      it 'should assign the role of the user' do
        get :show
        expect(assigns(:administrator)).to be_true
      end

      it 'should render the "show" template' do
        get :show
        expect(response).to render_template('show')
      end
    end

    context 'when not authenticated' do
      before do
        UserAuthenticator.any_instance.stub(:authenticated?).and_return(false)
      end

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
          expect(response).to redirect_to('https://auth-test.berkeley.edu/cas/logout?service')
        end
      end
    end

    it 'should redirect to #new' do
      delete :destroy
      expect(response).to redirect_to(action: :new)
    end
  end
end
