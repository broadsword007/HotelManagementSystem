Rails.application.routes.draw do
  resources :rooms
  resources :hotels
  devise_for :users, controllers: {
      sessions: 'users/sessions',
      registrations: 'users/registrations'
  }
  devise_scope :user do post '/users/updatepicture' => 'users/registrations#update_picture' end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'root#index'
  get '/adminpanel', to: 'admin_panel#index'
end
