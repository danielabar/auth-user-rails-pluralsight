Rails.application.routes.draw do
  get 'password/reset'
  get 'password/forgot'
  resources :users

  get 'home/login'
  post 'home/login'

  get 'home/index'
  root 'home#index'
end
