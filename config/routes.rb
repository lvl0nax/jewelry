Rails.application.routes.draw do

  resources :dopinfos

  resources :infos
  #for twitter authentfication
  match "/delayed_job" => DelayedJobWeb, :anchor => false, via: [:get, :post]
  match '/auth/:provider/callback' => 'authentications#create', via: [:get, :post]
  match '/user/test' => 'users#test', via: [:get, :post]
  resources :authentications

  devise_for :users, :path_prefix => 'd'
  match '/user/:id' => 'users#show', via: [:get, :post]
  resources :users

  # post 'search' => "products#search"
  get 'search' => 'products#search'
  # get 'test_search' => "products#search", :as => "test_search"
  resources :categories do
    resources :products
  end
  match 'test' => 'searches#test', via: [:get, :post]
  get '/searches/test' => 'searches#test'

  resources :searches
  resources :pages do

    get 'import_excell', :on => :collection
  end

  get 'import_excel', :to => "application#import_excel"
  get 'image_convert', :to => "application#image_convert"
  get 'clear_images', :to => "application#clear_images"

  post '/card' => 'card#create'

  resources :products do
    collection do
      post 'upload_photos'
    end
  end
  resources :card do
    collection do
      get 'add_to_card'
      get 'add_to_cart'
      get 'remove_from_cart'
      post 'change_status'
      get 'list'
      get 'show_card'
    end

  end
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root 'pages#index'#'categories#index'

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
   match ':controller(/:action(/:id(.:format)))', via: [:get, :post]
end
