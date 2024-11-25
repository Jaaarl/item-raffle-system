Rails.application.routes.draw do
  constraints(ClientDomainConstraint.new) do
    root to: 'client/homepage#index', as: 'client_root'
    namespace :client do
      resources :homepage, only: [:index]
      resources :menu, only: [:index]
      resources :me, only: [:index]
      namespace :me do
        resources :order_history, only: [:index]
        resources :lottery_history, only: [:index]
        resources :winning_history, only: [:index]
        resources :invitation_history, only: [:index]
      end
      resources :shop, only: [:index, :show]
      resources :location do
        member do
          patch :make_default
        end
      end
      resources :invite, only: [:index, :show]
      resources :lottery, only: [:index, :show]
      post ':id/buy_tickets', to: 'lottery#buy', as: 'buy_tickets'
      post ':id/buy_offer', to: 'shop#buy', as: 'buy_offer'
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
      resources :offer
      resources :order, only: [:index]  do
        member do
          patch :pay
          patch :cancel
        end
      end
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
      resources :winner, only: [:index] do
        member do
          patch :submit
          patch :pay
          patch :ship
          patch :deliver
          patch :publish
          patch :remove_publish
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
