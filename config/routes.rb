Rails.application.routes.draw do
  root 'home#index'
  constraints(ClientDomainConstraint.new) do
    resources :clients, only: [:index ]
    devise_scope :user do
      get 'client/login', to: 'client/sessions#new', as: :new_client_session
      post 'client/login', to: 'client/sessions#create', as: :client_session
      delete 'client/logout', to: 'client/sessions#destroy', as: :destroy_client_session

      get 'client/register', to: 'client/registrations#new', as: :new_client_registration
      post 'client/register', to: 'client/registrations#create', as: :client_registration
    end
  end
  constraints(AdminDomainConstraint.new) do
    resources :admins, only: [:index]
    devise_for :users, controllers: {
      sessions: 'admin/sessions',
    }, as: :admin
  end
end
