Rails.application.routes.draw do
  devise_for :users
  resources :comments

  resources :bugs
  devise_scope :user do
  	get "sign_in", to: "devise/sessions#new"
	end

	root "bugs#index"
end
