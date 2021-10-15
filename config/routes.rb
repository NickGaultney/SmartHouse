Rails.application.routes.draw do
  resources :tests
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  root 'buttons#index'
  get '/buttons/edit_mode', to: 'buttons#edit_mode'

  resources :buttons
  resources :devices
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
