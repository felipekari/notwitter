Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users/registrations' }

  resources :tweets do
    resources :likes
    member do
      post :retweet
    end
  end

  resources :users, only: [:show] do
    resources :followers, only: [:create, :destroy]
  end
  get 'home', to: 'pages#home'
  root "pages#home"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
