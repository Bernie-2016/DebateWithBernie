Rails.application.routes.draw do
  root 'images#home'
  get '/make', to: 'images#make', as: 'make'
  post '/', to: 'images#create'
  get '/share/:id', to: 'images#public', as: 'image_share'
  resources :images, only: [:show] do
    get :download
  end
end
