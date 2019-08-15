Rails.application.routes.draw do
  constraints subdomain: /^(pnb-ewallet-api)$/ do
    post "/auth/login", to: "session#login"
    resources :users do
      collection do
        get :current
      end
    end
    resources :wallets, only: [:index, :show] do
      member do
        post :transfer
      end
    end
  end
end
