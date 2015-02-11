Rails.application.routes.draw do
  get 'home/index'

  devise_for :admins, module: 'admins' 
  resources :requests

  devise_for :users, module: 'users' 
  resources :comments

  resources :bugs, :path => 'tickets'
  devise_scope :user do
  	get "sign_in", to: "users/sessions#new", :as => :login
	end

	root "home#index"
end
