Rails.application.routes.draw do
  devise_for :admins, module: 'admins' 
  resources :requests

  devise_for :users, module: 'users' 
  resources :comments

  resources :bugs
  devise_scope :user do
  	get "sign_in", to: "users/sessions#new", :as => :login
	end

	root "bugs#index"
end
