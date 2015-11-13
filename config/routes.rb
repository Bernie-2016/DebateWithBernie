Rails.application.routes.draw do

  get '/', to: 'images#home'
  get '/pick', to: 'images#pick', as: 'pick'
  post '/', to: 'images#create'
  resources :images, only: [:show] do
    get :download
  end
end
