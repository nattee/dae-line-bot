Rails.application.routes.draw do
  get 'api/callback', to: 'api#get_callback'
  post 'api/callback'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

end
