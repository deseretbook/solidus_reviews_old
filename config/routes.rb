Spree::Core::Engine.routes.draw do
  namespace :admin do
    resources :reviews, only: [:index, :destroy, :edit, :update] do
      member do
        get :approve
      end
      resources :feedback_reviews, only: [:index, :destroy]
    end
    resource :review_settings, only: [:edit, :update]
  end

  resources :products do
    resources :reviews, only: [:index, :new, :create] do
    end
  end
  post '/reviews/:review_id/feedback(.:format)' => 'feedback_reviews#create', as: :feedback_reviews

  namespace :api do
    resources :products do
      resources :reviews, only: [:index, :create, :update, :destroy] do
      end
    end
  end
end
