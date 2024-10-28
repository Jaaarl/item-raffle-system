Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }
  devise_scope :user do
    get 'admin/login', to: 'admin/sessions#new', as: :new_admin_session
    post 'admin/login', to: 'admin/sessions#create', as: :admin_session
    delete 'admin/logout', to: 'admin/sessions#destroy', as: :destroy_admin_session
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  root 'home#index'
  constraints(ClientDomainConstraint.new) do
    resources :clients, only: [:index ]
  end
  constraints(AdminDomainConstraint.new) do
    resources :admins, only: [:index]
  end
end
