Rails.application.routes.draw do
  root 'welcome#welcome'

  get 'garage', to: 'rooms#garage'
  get 'laundry', to: 'rooms#laundry'
  get 'kitchen', to: 'rooms#kitchen'
  get 'dining', to: 'rooms#dining'
  get 'living', to: 'rooms#living'
  get 'pavilion', to: 'rooms#pavilion'
  get 'hallway', to: 'rooms#hallway'
  get 'guest_1', to: 'rooms#guest_1'
  get 'guest_2', to: 'rooms#guest_2'
  get 'guest_bathroom', to: 'rooms#guest_bathroom'
  get 'master_bathroom', to: 'rooms#master_bathroom'
  get 'master_bedroom', to: 'rooms#master_bedroom'
  get 'master_closet', to: 'rooms#master_closet'
  get 'front_patio', to: 'rooms#front_patio'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
