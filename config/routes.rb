Rails.application.routes.draw do
  # =====================
  # 仮ログイン
  # =====================
  root "sessions#new"

  get    "/login",  to: "sessions#new",    as: :login
  post   "/login",  to: "sessions#create"
  get "/logout", to: "sessions#destroy"  # テスト用、一時的
  # delete "/logout", to: "sessions#destroy" JSエラーのためGETリクエストになる。こちらは機能していない。

  # =====================
  # Users（一般社員）
  # =====================
  namespace :users do
    root "dashboard#index"

    resources :training_schedules, only: [:index, :show]
    resources :training_participations, only: [:index, :show]
    resources :plans, only: [:index, :show]
  end

  # =====================
  # Admin（管理者）
  # =====================
  namespace :admin do
    root "dashboard#index"

    resources :trainings
    resources :training_schedules
    resources :plans
    resources :users_list, only: [:index, :show]
  end
end
