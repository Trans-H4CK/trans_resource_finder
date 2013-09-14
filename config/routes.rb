TransResourceFinder::Application.routes.draw do

  namespace :api, :defaults => {:format => 'json'} do
    namespace :v1, :constraints => ApiConstraints.new(:version => 1) do
      resources :resources, :only => [:show, :index]
    end
  end
end
