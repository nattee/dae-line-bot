Rails.application.routes.draw do
  get 'api/test'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get 'test', to: 'api#test'
end
