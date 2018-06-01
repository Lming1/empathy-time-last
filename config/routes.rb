Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users/registrations' }
  root 'posts#index'
    match "posts/data", :to => "posts#data", :as => "data", :via => "get"
    match "posts/db_action", :to => "posts#db_action", :as => "db_action", :via => "get"
  resources :posts
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
