Spree::Core::Engine.routes.draw do
  namespace :admin do
    resources :reviews, only: %i[index destroy edit update] do
      member do
        get :approve
      end
      resources :feedback_reviews, only: %i[index destroy]
    end
    resource :review_settings, only: %i[edit update]
  end

  resources :products do
    resources :reviews, only: %i[index new create] do
    end
  end
  post '/reviews/:review_id/feedback(.:format)' => 'feedback_reviews#create', as: :feedback_reviews
end
