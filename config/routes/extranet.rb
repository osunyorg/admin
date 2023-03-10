# Full :as names are useful for the resolution of links like [:alumni, cohort]
namespace :contacts do
  get 'persons' => 'persons#index', as: :university_persons
  get 'persons/:id' => 'persons#show', as: :university_person
  get 'organizations' => 'organizations#index', as: :university_organizations
  get 'organizations/:id' => 'organizations#show', as: :university_organization
  get 'search' => 'search#index', as: :search
  root to: 'persons#index'
end
namespace :alumni do
  get 'cohorts' => 'cohorts#index', as: :education_cohorts
  get 'cohorts/:id' => 'cohorts#show', as: :education_cohort
  get 'organizations' => 'organizations#index', as: :university_organizations
  get 'organization/:id' => 'organizations#show', as: :university_organization
  get 'persons' => 'persons#index', as: :university_persons
  get 'persons/:id' => 'persons#show', as: :university_person
  get 'years' => 'academic_years#index', as: :education_academic_years
  get 'years/:id' => 'academic_years#show', as: :education_academic_year
  root to: 'persons#index'
end
resources :organizations, except: :destroy do
  collection do
    get 'search' => 'organizations#search', as: :search, defaults: { format: 'json' }
  end
end
namespace :posts do
  get 'categories' => 'categories#index', as: :categories
  get 'categories/:slug' => 'categories#show', as: :category
  # Categories before slug !
  get ':slug' => 'posts#show', as: :post
  root to: 'posts#index'
end
namespace :library do
  root to: 'documents#index'
end
get 'account' => 'account#show', as: :account
get 'account/edit' => 'account#edit', as: :edit_account
patch 'account' => 'account#update'
scope :account do
  resources :experiences, controller: 'experiences', except: [:index, :show]
  get 'personal_data' => 'personal_data#edit', as: :edit_personal_data
  patch 'personal_data' => 'personal_data#update', as: :personal_data
end
get 'terms' => 'pages#terms', as: :terms
get 'privacy-policy' => 'pages#privacy_policy', as: :privacy_policy
get 'cookies-policy' => 'pages#cookies_policy', as: :cookies_policy
get 'data' => 'pages#data', as: :data
get 'style' => 'style#index', as: :style, constraints: { format: 'css' }
