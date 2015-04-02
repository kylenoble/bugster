Rails.application.routes.draw do
  

  devise_for :admins, module: 'admins' 

  devise_scope :user do
    get "sign_in", to: "users/sessions#new", :as => :login
  end

  devise_for :users, module: 'users' 

  scope '/decision7' do
    resources :requests

    resources :comments

    resources :bugs, :path => 'tickets'
  end

  scope '/ignitetek' do  
    resources :requests

    resources :comments

    resources :bugs, :path => 'tickets'

  end

  get "how-to", to: "how_to#index"

  get 'home/index'

  match '/email_suggestions', to: 'email_suggestions#index', via: :get

	root "home#index"
end
