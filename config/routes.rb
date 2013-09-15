TransResourceFinder::Application.routes.draw do

	root :to => "resources#new"
  namespace :api, :defaults => {:format => 'json'} do
    namespace :v1, :constraints => ApiConstraints.new(:version => 1) do
      resources :resources, :only => [:show, :index]
      resources :categories, :only => [:index]
    end
  end

  resources :resources, :only => [:create, :new, :index]
end
