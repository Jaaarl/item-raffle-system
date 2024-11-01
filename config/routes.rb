Rails.application.routes.draw do
  root 'home#index'
  constraints(ClientDomainConstraint.new) do
    resources :clients, only: [:index]
    namespace :client do
      resources :homepage, only: [:index]
    end
    devise_for :users, controllers: {
      sessions: 'client/sessions',
      registrations: 'client/registrations',
    }, as: :client
    namespace :client do
      resources :menu, only: [:index]
    end
  end
  constraints(AdminDomainConstraint.new) do
    resources :admins, only: [:index]
    devise_for :users, controllers: {
      sessions: 'admin/sessions',
    }, as: :admin
    namespace :admin do
      resources :dashboard, only: [:index]
    end
  end
end
