Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
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

    devise_scope :user do
      get 'admin/login', to: 'admin/sessions#new', as: :new_admin_session
      post 'admin/login', to: 'admin/sessions#create', as: :admin_session
      delete 'admin/logout', to: 'admin/sessions#destroy', as: :destroy_admin_session
    end
  end
end
