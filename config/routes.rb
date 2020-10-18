Rails.application.routes.draw do
  get 'users/index'
  get 'users/show'
  devise_for :users
  resources :users, :only => [:index, :show]
  root 'static_pages#top'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
