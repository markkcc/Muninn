Rails.application.routes.draw do
  get 'search/index'

  resources :scans#, only: [:show, :new, :create]

  root 'scans#new'
end
