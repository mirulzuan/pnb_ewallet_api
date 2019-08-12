Rails.application.routes.draw do
  constraints subdomain: /^(pnb-api)$/ do
    post "/auth/login", to: "session#login"
    resources :users
  end
end
