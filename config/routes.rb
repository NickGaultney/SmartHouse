Rails.application.routes.draw do
  resources :slave_switches
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  mount ActionCable.server, at: '/cable'
  root 'buttons#index'

  get '/buttons/edit_mode', to: 'buttons#edit_mode'
  get '/buttons/:id/toggle', to: 'buttons#toggle'
  get '/scan', to: 'devices#scan'
  get '/bump', to: 'devices#bump'

  resources :buttons
  resources :devices
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
