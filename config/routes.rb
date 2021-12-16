#commit test
Rails.application.routes.draw do
  resources :groups
  resources :buttons
  resources :outputs
  resources :inputs
  resources :io_devices
  resources :tasmota_configs
  resources :network_devices
  resources :inputs
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  mount ActionCable.server, at: '/cable'
  root 'welcome#home'

  get '/bump', to: 'buttons#bump'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
