Rails.application.routes.draw do

  root 'boxes#new'

  resources :boxes, only: [:new, :create, :show] do
    member do
      get :authenticate
      post :upload
    end
  end

end
