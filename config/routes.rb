Rails.application.routes.draw do
  require 'resque/server'
  mount Resque::Server.new, at: '/resque'

  resources :domains
  resources :unifi_sites
  resources :statements, except: [:create, :new, :destroy]
  post "statements_filter", to: "statements#filter"
  post "computers_filter", to: "computers#filter"
  post "domains_filter", to: "domains#filter"
  post "unifi_sites_filter", to: "unifi_sites#filter"
  get "statements/:id/invoice", to: "statements#pdf", as: "pdf_statement"
  resources :accounts, except: [:show] do
    resources :billers, only: [:create, :new, :edit, :update]
    # post "computer_billings", to: "billers#create_computer_billing", as: "computer_billings"
    # patch "computer_billings/:id", to: "billers#update_computer_billing", as: "computer_billing"
    resources :computer_billings, only: [:create, :new, :edit, :update]
    resources :api_keys, only: :update
    # resources :roles, except: [:show]
    get "roles/new", to: "account_roles#new"
    post "roles/new", to: "account_roles#create"
    delete "roles/:user_id", to: "account_roles#destroy", as: "role_removal"
    get 'roles', to: 'account_roles#index'
  end

  resources :computers, except: [:new, :create], shallow: true do
    resources :jobs, except: [ :index ]
  end
  
  namespace :api do
    namespace :v1 do
      defaults format: :json do
        get 'computers/key/:key', to: "computers#show_by_key", as: "computer_key"
        post "jobs/:id/completed", to: "jobs#completed", as: "job_completed"
        resources :computers, only: [ :create, :show, :update ], shallow: true do
          resources :jobs, only: [ :index ], shallow: true do
            resources :job_events, only: [ :create ]
          end
        end
      end
    end
  end

  root "pages#home"
  post "sign_up", to: "users#create"
  get "sign_up", to: "users#new"
  resources :confirmations, only: [:create, :edit, :new], param: :confirmation_token
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy"
  get "login", to: "sessions#new"
  resources :passwords, only: [:create, :edit, :new, :update], param: :password_reset_token
  put "profile", to: "users#update"
  get "profile", to: "users#edit"
  delete "profile", to: "users#destroy"
  get "users", to: "user_roles#index"
  get "dashboard", to: "dashboards#index"
  resources :user_administration, except: [:destroy] do
    get "roles", to: "user_roles#edit"
    post "roles", to: "user_roles#update"
  end
end
