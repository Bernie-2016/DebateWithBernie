Rails.application.routes.draw do

  get '/', to: 'images#home'
  get '/pick', to: 'images#pick', as: 'pick'
  post '/', to: 'images#create'
  get '/images/:id', to: 'images#show'
end
