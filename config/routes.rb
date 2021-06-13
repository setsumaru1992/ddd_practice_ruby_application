Rails.application.routes.draw do
  root to: "debug/people#root"

  namespace :debug do
    resources :people
    namespace :person do
      resources :groups
    end
  end
end
