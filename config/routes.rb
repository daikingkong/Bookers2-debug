Rails.application.routes.draw do
  devise_for :users

  root "homes#top"
  get "home/about"=>"homes#about"

  resources :books, only: [:index,:show,:edit,:create,:destroy,:update] do
    resources :book_comments, only: [:create, :destroy]
    resource :favorites, only: [:create, :destroy]
  end

  resources :users, only: [:index,:show,:edit,:update] do
    resource :relationships, only: [:create, :destroy]
    get 'followings' => 'relationships#followings', as: 'followings'
    get 'followers' => 'relationships#followers', as: 'followers'
    get 'search' => 'users#search'
    # get "daily_posts" => "users#daily_posts"
  end

  resources :groups, only: [:new, :create, :index, :show, :edit, :update] do
    get 'join' => 'groups#join'
    get 'leave' => 'groups#leave'
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get '/search' => 'searches#search'

  resources :chats, only: [:show, :create]
end