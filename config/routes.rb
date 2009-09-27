RUBYGEM_NAME_MATCHER = /[A-Za-z0-9\-\_\.]+/

ActionController::Routing::Routes.draw do |map|

  map.json_gem "/gems/:id.json",
    :controller   => "rubygems",
    :action       => "show",
    :format       => "json",
    :requirements => { :id => RUBYGEM_NAME_MATCHER }
  map.json_gem_version "/gems/:rubygem_id/versions/:id.json",
    :controller   => "versions",
    :action       => "show",
    :format       => "json",
    :requirements => { :id => RUBYGEM_NAME_MATCHER }
  map.xml_gem "/gems/:id.xml",
    :controller   => "rubygems",
    :action       => "show",
    :format       => "xml",
    :requirements => { :id => RUBYGEM_NAME_MATCHER }   
  map.xml_gem_version "/gems/:rubygem_id/versions/:id.xml",
    :controller   => "versions",
    :action       => "show",
    :format       => "xml",
    :requirements => { :id => RUBYGEM_NAME_MATCHER }
  map.yaml_gem "/gems/:id.yaml",
    :controller   => "rubygems",
    :action       => "show",
    :format       => "yaml",
    :requirements => { :id => RUBYGEM_NAME_MATCHER }   
  map.yaml_gem_version "/gems/:rubygem_id/versions/:id.yaml",
    :controller   => "versions",
    :action       => "show",
    :format       => "yaml",
    :requirements => { :id => RUBYGEM_NAME_MATCHER }

  map.resource  :dashboard,  :only => :show
  map.resource  :profile
  map.resources :statistics, :only => :index, :as => "stats"

  map.resource :migrate,
               :only         => [:create, :update],
               :controller   => "migrations",
               :path_prefix  => "/gems/:rubygem_id",
               :requirements => { :rubygem_id => RUBYGEM_NAME_MATCHER }

  map.resources :rubygems,
                :as           => "gems",
                :requirements => { :id => RUBYGEM_NAME_MATCHER },
                :member       => [:version] do |rubygems|

    rubygems.resource :owners, :only => [:show, :create, :destroy]

    rubygems.resource :subscription, :only => [:create, :destroy]

    rubygems.resources :versions,
      :only         => [:index, :show],
      :requirements => { :rubygem_id => RUBYGEM_NAME_MATCHER, :id => RUBYGEM_NAME_MATCHER }
  end

  map.search "/search", :controller => "searches", :action => "new"
  map.resource :api_key, :only => [:show, :reset], :member => {:reset => :put}

  map.sign_up  'sign_up', :controller => 'clearance/users',    :action => 'new'
  map.sign_in  'sign_in', :controller => 'clearance/sessions', :action => 'new'
  map.sign_out 'sign_out',
    :controller => 'clearance/sessions',
    :action     => 'destroy',
    :method     => :delete

  map.root :controller => "home", :action => "index"
end
