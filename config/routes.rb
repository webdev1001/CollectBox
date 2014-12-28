Rails.application.routes.draw do

  root 'boxes#new'

  resources :boxes, only: [:new, :create, :show]

end
