Rails.application.routes.draw do
  resources :line_groups
  resources :plans
  resources :stations
  resources :checkins
  resources :runs
  resources :athletes
  resources :courses
  resources :races
  get 'api/callback', to: 'api#get_callback'
  post 'api/callback'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

end
