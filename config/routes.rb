Rails.application.routes.draw do
  constraints subdomain: /^(pnb-api)$/ do
    post "/auth/login", to: "session#login"
    resources :users do
      collection do
        get :current
      end
    end
    resources :wallets, only: [:show] do
      member do
        post :transfer
      end
    end
  end
end
