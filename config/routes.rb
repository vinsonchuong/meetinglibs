MeetingLibs::Application.routes.draw do
  root :to => 'sessions#show'
  resource :session, except: [:edit, :update] do
    get :calnet
  end

  resources :events, only: [:index]
end
