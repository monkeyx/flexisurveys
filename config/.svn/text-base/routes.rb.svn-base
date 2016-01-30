ActionController::Routing::Routes.draw do |map|
  map.forgot_password '/forgot_password', :controller => 'passwords', :action => 'new'
  map.change_password '/change_password/:reset_code', :controller => 'passwords', :action => 'reset'
  map.resources :passwords

  map.pre_deploy 'deploy/pre', :controller => 'deployment', :action => 'pre_deploy'
  map.post_deploy 'deploy/post', :controller => 'deployment', :action => 'post_deploy'
  
  map.feedback 'feedbacks', :controller => 'feedbacks', :action => 'create'
  map.new_feedback 'feedbacks/new', :controller => 'feedbacks', :action => 'new'
  map.logout '/logout', :controller => 'admin_sessions', :action => 'destroy'
  map.login '/login', :controller => 'admin_sessions', :action => 'new'
  map.register '/register', :controller => 'admin_users', :action => 'create'
  map.signup '/signup', :controller => 'admin_users', :action => 'new'
  map.activate '/activate/:activation_code', :controller => 'admin_users', :action => 'activate', :activation_code => nil
  map.account '/account', :controller => 'admin_users', :action => 'account' 
  map.features '/features', :controller => 'quiz', :action => 'features'
  map.upgrade '/upgrade', :controller => 'quiz', :action => 'upgrade'
  map.terms '/terms', :controller => 'quiz', :action => 'terms'
  map.tutorial '/tutorial', :controller => 'quiz', :action => 'tutorial'
  
  map.resource  :admin_session
  
  map.resources :admin_users, :member => {:suspend => :put,
                                       :unsuspend => :put,
                                       :purge => :delete}
  map.home '', :controller => 'quiz', :action => 'index'
  map.quiz '/quiz/*path', :controller => 'quiz', :action => 'show'
  
  map.resources :question_answers
  map.resources :questions
  map.resources :question_sets
  map.resources :surveys
  
  map.csv 'surveys/:id/csv', :controller => 'surveys', :action => 'csv'
  map.xml 'surveys/:id/xml', :controller => 'surveys', :action => 'xml'
  map.import 'import', :controller => 'surveys', :action => 'import'
  
  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  # map.root :controller => "welcome"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing or commenting them out if you're using named routes and resources.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
