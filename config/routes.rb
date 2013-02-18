MeetingLibs::Application.routes.draw do
  root :to => 'sessions#show'
  resource :session, except: [:edit, :update] do
    get :calnet
  end

  defaults format: :json do
    resources :events, only: [:index, :update]
  end
end
