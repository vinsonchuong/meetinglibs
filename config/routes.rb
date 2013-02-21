MeetingLibs::Application.routes.draw do
  root :to => 'sessions#show'
  resource :session, except: [:edit, :update] do
    get :calnet
  end

  defaults format: :json do
    resources :events, only: [:index, :create, :update, :destroy] do
      resources :hosts, only: [:index, :show, :create, :update, :destroy]
      resources :visitors, only: [:index, :show, :create, :update, :destroy]
    end
  end
end
