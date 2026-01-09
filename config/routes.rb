Rails.application.routes.draw do
  # =====================
  # 仮ログイン
  # =====================
  root "sessions#new"

  get    "/login",  to: "sessions#new"
  post   "/login",  to: "sessions#create"
  delete "/logout", to: "sessions#destroy"

  # =====================
  # Users（一般社員）
  # =====================
  namespace :users do
    root "dashboard#index"

    resources :training_schedules, only: [:index, :show]
    resources :training_histories, only: [:index]
    resources :plans, only: [:index, :show]
  end

  # =====================
  # Admin（管理者）
  # =====================
  namespace :admin do
    root "dashboard#index"

    resources :trainings
    resources :training_schedules, only:[:index]
    resources :plans
    resources :users_list, only: [:index, :show]
  end

  get "up" => "rails/health#show", as: :rails_health_check
end

