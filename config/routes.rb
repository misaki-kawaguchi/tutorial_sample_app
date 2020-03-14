Rails.application.routes.draw do
  root 'static_pages#home'

  get  '/help',    to: 'static_pages#help'
  get  '/about',   to: 'static_pages#about'
  get  '/contact', to: 'static_pages#contact'
  
  # サインアップ
  get  '/signup',  to: 'users#new'
  post '/signup',  to: 'users#create'
  
  # ログイン・ログアウト
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  
  #ユーザー情報
  resources :users
  
  #アカウント有効化
  resources :account_activations, only: [:edit]
  
  # パスワード再設定
  resources :password_resets,     only: [:new, :create, :edit, :update]
  
  #マイクロポスト作成
  resources :microposts,          only: [:create, :destroy]
end