Rails.application.routes.draw do

  get '/', to: 'images#home'
  get '/make', to: 'images#make', as: 'make'
  post '/', to: 'images#create'
  resources :images, only: [:show] do
    get :download
  end
end
