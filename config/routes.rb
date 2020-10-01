Rails.application.routes.draw do
  devise_for :users
  #devise_for :models
  resources :tasks
  resources :projects

   get 'tasks/new/:project_id', to: 'tasks#new'
   root to: "projects#index"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
