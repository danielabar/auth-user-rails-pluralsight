Rails.application.routes.draw do
  resources :users

  get 'home/login'
  post 'home/login'

  get 'home/index'
  root 'home#index'
end
