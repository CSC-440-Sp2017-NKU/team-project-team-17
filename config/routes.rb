Rails.application.routes.draw do
  resources :users
  resources :answers
  resources :questions
  resources :courses
  root 'courses#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
