Website::Application.routes.draw do


  mount Ckeditor::Engine => '/ckeditor'

  post '/search' => "search#index"

  devise_for :users, :path => 'account', :controllers => {
    :omniauth_callbacks => "users/omniauth_callbacks",
    :registrations => "registrations"
  }
  delete "/account/auth/:provider/unbind" => "users#auth_unbind", as: "unbind_account"

  resources :projects do
    member do
      get :preview
      get :submit
      post :donate
      post :add_volunteer
      post :remove_volunteer
    end
    resources :comments
  end

  namespace :cpanel do
    resources :users
    resources :donations
    resources :projects, only: [:index] do
      member do
        get :volunteers
        get :publish
        get :unpublish
      end
    end
    resources :comments, only: [:index, :destroy]
    get "dashboard" => "dashboard#index"
    get "/" => "dashboard#index"
  end

  root :to => 'home#index'

  resources :users, only: [:show] do
    member do
      get :projects
    end
  end
end
