Rails.application.routes.draw do
  get '/signup', to: "users#new"
  root "static_pages#home"
  # get "static_pages/home"
  # get "static_pages/help"
  # get "static_pages/about"
  # get "static_pages/contact"
  get "/about", to: "static_pages#about"
  get "/help", to: "static_pages#help", as: "helf"
  get "/contact", to: "static_pages#contact"
  resources :users
end
