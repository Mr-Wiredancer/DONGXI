Website::Application.routes.draw do

  post '/search' => "search#index"

  devise_for :users, :path => 'account', :controllers => {
    :omniauth_callbacks => "users/omniauth_callbacks",
    :registrations => "registrations"
  }

  resources :projects do
    member do
      get :preview
      get :submit
      get :publish
      get :unpublish
    end
  end

  namespace :cpanel do
    resources :users
  end

  root :to => 'home#index'

  resources :users do
    member do
      get :projects
    end
  end
end
