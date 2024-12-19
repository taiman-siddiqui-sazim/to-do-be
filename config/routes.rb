Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :tasks, only: [:index, :show, :create, :update] do
        member do
          patch :update_completion
        end
      end
    end
  end
end
