Rails.application.routes.draw do
  constraints subdomain: /^(pnb-api)$/ do
    resources :users
  end
end
