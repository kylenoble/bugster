Rails.application.routes.draw do
  get 'home/index'

  devise_for :admins, module: 'admins' 
  resources :requests

  devise_for :users, module: 'users' 
  resources :comments

  get "how-to", to: "how_to#index"

  resources :bugs, :path => 'tickets'
  devise_scope :user do
  	get "sign_in", to: "users/sessions#new", :as => :login
	end

  match '/email_suggestions', to: 'email_suggestions#index', via: :get

	root "home#index"
end
