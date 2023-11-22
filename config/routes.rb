Rails.application.routes.draw do 

  devise_for :admin_users, ActiveAdmin::Devise.config 
  ActiveAdmin.routes(self) 

  root to: "homes#index"
  
  devise_for :users, controllers: { confirmations: 'users/confirmations', 
    omniauth_callbacks: 'users/omniauth_callbacks',
    registrations: 'registrations', sessions: 'users/sessions', sessions: 'sessions'
   }
  
  devise_scope :user do
    get 'users/confirmations/verify_otp'
    post 'users/confirmations/verify_otp'
    namespace :users do
      post 'verify_otp', to: 'sessions#verify_otp', as: 'verify_otp'
    end
  end


  get '/search', to: 'homes#search', as: 'search'

  resources :category
  resources :products
  resources :products do
    post 'create_direct_order', on: :member
  end

  resource :cart, only: [:show] do
    post 'add_to_cart/:product_id', action: :add_to_cart, on: :member, as: :add_to_cart
    post 'increase_quantity/:cart_item_id', action: :increase_quantity, on: :member, as: :increase_quantity
    post 'decrease_quantity/:cart_item_id', action: :decrease_quantity, on: :member, as: :decrease_quantity
    delete 'remove_from_cart/:cart_item_id', action: :remove_from_cart, on: :member, as: :remove_from_cart
    post 'place_order', on: :member
    get '/order_success', to: 'carts#order_success', as: 'order_success'
  end

  resources :orders do
    member do
      put :mark_as_out_for_delivery
      get :verify
      put :mark_delivered
    end
  end

  get 'confirm_order/:product_id', to: 'orders#confirm_order', as: 'confirm_order'
  post 'place_order/:product_id', to: 'orders#place_order', as: 'place_order'
  get '/order_success/:product_id', to: 'orders#order_success', as: 'order_success'


end
