Rails.application.routes.draw do
  root 'images#new'

  post '/', to: 'images#create'
  resources :images, only: [:show]
end
