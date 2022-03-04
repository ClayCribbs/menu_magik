Rails.application.routes.draw do
  root 'menu_items#index'
  resources :menu_items
end
