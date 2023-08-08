Rails.application.routes.draw do 
  # get 'otp_verifiction/new'
  # post 'otp_verifiction/create'

  devise_for :admin_users, ActiveAdmin::Devise.config 
  ActiveAdmin.routes(self) 
  
  devise_for :users, controllers: { confirmations: 'users/confirmations', 
    omniauth_callbacks: 'users/omniauth_callbacks',
    registrations: 'registrations'
   }
  

  devise_scope :user do
    get 'users/confirmations/verify_otp'
    post 'users/confirmations/verify_otp'
    #, to: 'users/confirmations/verify_otp'
  end
  #get 'verification', to: 'verification#verify'




  get '/homes', to: "homes#index"
  get '/search', to: 'homes#search', as: 'search'

  # namespace :users do
  #   resource :confirmation, only: [] do
  #     post 'send_otp', on: :member
  #     post 'verify_otp', on: :member
  #   end
  # end
   
end
