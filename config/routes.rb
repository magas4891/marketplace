require 'sidekiq/web'

Rails.application.routes.draw do
  get 'comments/create'
  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  resources :projects do
    resources :comments, module: :projects
  end

  resource :subscription

  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks'}
  root to: 'projects#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
