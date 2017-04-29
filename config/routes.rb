Rails.application.routes.draw do
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'
  get    '/users/me',   to: 'users#show_me'
  post    '/search',   to: 'search#show'  
  get    '/search',   to: 'courses#index' 

  resources :users do
    collection { post :import }
  end
  resources :answers
  resources :questions
  resources :courses
  root 'courses#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
