Rails.application.routes.draw do
  namespace :users do
    get "training_schedule/index"
    get "training_schedule/show"
    get "training_history/index"
    get "dashboard/index"
  end
  namespace :admin do
    get "user_list/index"
    get "user_list/show"
    get "training/new"
    get "training/index"
    get "training/show"
    get "training/edit"
    get "plan/new"
    get "plan/index"
    get "plan/show"
    get "plan/edit"
    get "dashboard/index"
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
