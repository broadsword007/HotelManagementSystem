Rails.application.routes.draw do
  resources :room_categories
  resources :comments
  resources :rooms
  devise_for :users, controllers: {
      sessions: 'users/sessions',
      registrations: 'users/registrations'
  }
  devise_scope :user do post '/users/updatepicture' => 'users/registrations#update_picture' end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'root#index'
  get '/adminpanel', to: 'admin_panel#index'
  post '/room/:id/updatepicture', to: "rooms#update_picture", as: 'room_picture_update'
  post '/roomcategory/:id/updatepicture', to: "room_categories#update_picture", as: 'room_category_picture_update'
end
