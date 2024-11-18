Rails.application.routes.draw do
  constraints(ClientDomainConstraint.new) do
    root to: 'client/homepage#index', as: 'client_root'
    namespace :client do
      resources :homepage, only: [:index]
      resources :menu, only: [:index]
      resources :me, only: [:index]
      resources :place
      resources :invite, only: [:index, :show]
      resources :lottery, only: [:index, :show]
    end
    devise_for :users, controllers: {
      sessions: 'client/sessions',
      registrations: 'client/registrations',
    }, as: :client
  end
  constraints(AdminDomainConstraint.new) do
    root to: 'admin/dashboard#index', as: 'admin_root'
    devise_for :users, controllers: {
      sessions: 'admin/sessions',
    }, as: :admin
    namespace :admin do
      resources :dashboard, only: [:index]
      resources :user_management, only: [:index]
      resources :item_management
      resources :categories
      resources :ticket, only: [:index] do
        member do
          patch :cancel
        end
      end
      resources :item_management do
        member do
          patch :start
          patch :pause
          patch :end
          patch :cancel
        end
      end
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
