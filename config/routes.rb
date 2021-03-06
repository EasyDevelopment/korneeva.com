Romans::Application.routes.draw do

  resources :songs
  resources :feedbacks, except: [:show]  do
    put :publish, on: :member
    get :not_published, on: :collection
  end

  get '/contacts' => 'messages#new', as: 'contacts'
  get '/anons' => 'pages#show', id: 'announcement'

  resources :messages, :disks, except: :show

  get "log_in" => "sessions#new", as: "log_in"
  get "log_out" => "sessions#destroy", as: "log_out"
  get "sign_up" => "users#new", as: "sign_up"
  resources :users, only: [:new, :create]
  resources :sessions, only: [:new, :create, :destroy]
  get 'admin_menu' => "welcome#index", as: 'admin_menu'

  get '/:id' => 'high_voltage/pages#show', :as => :static
  root to: 'pages#show', id: 'main_page'
end
