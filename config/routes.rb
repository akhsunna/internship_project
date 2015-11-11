Rails.application.routes.draw do

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  devise_for :users, controllers: { registrations: 'registrations', omniauth_callbacks: 'omniauth_callbacks' }

  resources :users, :moderators, :languages

  resources :books do

    resources :comments

    get 'genres'
    get 'copies'
    put 'create_copy'
    put 'add_remove_genre'
  end

  mount Soulmate::Server, at: "/autocomplete"

  resources :authors do
    resources :comments
  end

  resources :book_copies do
    get 'delete'

    put 'take'
    put 'return'
  end

  root to: 'books#index'
end
