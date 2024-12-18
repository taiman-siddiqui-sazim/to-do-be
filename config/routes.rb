Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :tasks, only: [:index, :show, :create, :update, :destroy] do
        patch :update_completion, on: :member
      end
    end
  end
end
