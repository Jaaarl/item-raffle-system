Rails.application.routes.draw do
  constraints(ClientDomainConstraint.new) do
    root to: 'client/homepage#index', as: 'client_root'
    resources :clients, only: [:index]
    namespace :client do
      resources :homepage, only: [:index]
      resources :menu, only: [:index]
      resources :me, only: [:index]
      resources :place
      resources :invite, only: [:index]
    end
    devise_for :users, controllers: {
      sessions: 'client/sessions',
      registrations: 'client/registrations',
    }, as: :client
  end
  constraints(AdminDomainConstraint.new) do
    root to: 'admin/dashboard#index', as: 'admin_root'
    resources :admins, only: [:index]
    devise_for :users, controllers: {
      sessions: 'admin/sessions',
    }, as: :admin
    namespace :admin do
      resources :dashboard, only: [:index]
      resources :user_management, only: [:index]
    end
  end
  namespace :api do
    namespace :v1 do
      resources :regions, only: %i[index show], defaults: { format: :json } do
        resources :provinces, only: :index, defaults: { format: :json }

      end
      resources :provinces, only: %i[index show], defaults: { format: :json } do
        resources :cities, only: :index, defaults: { format: :json }
      end

      resources :cities, only: %i[index show], defaults: { format: :json } do
        resources :barangays, only: :index, defaults: { format: :json }
      end

      resources :barangays, only: %i[index show], defaults: { format: :json }
    end
  end
end
