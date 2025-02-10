# Full :as names are useful for the resolution of links like [:alumni, cohort]

# Feature Contacts
namespace :contacts do
  get 'persons' => 'persons#index', as: :persons
  get 'persons/:id' => 'persons#show', as: :person
  get 'organizations' => 'organizations#index', as: :organizations
  get 'organizations/:id' => 'organizations#show', as: :organization
  get 'search' => 'search#index', as: :search
  root to: 'persons#index'
end

# Feature Alumni
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

# Search and Organization creation in the context of experiences
resources :organizations, only: [:new, :create] do
  collection do
    get 'search' => 'organizations#search', as: :search, defaults: { format: 'json' }
  end
end

# Feature Posts
namespace :posts do
  get 'categories' => 'categories#index', as: :categories
  get 'categories/:slug' => 'categories#show', as: :category
  # Categories before slug !
  get ':date/:slug' => 'posts#show', as: :post
  root to: 'posts#index'
end

# Feature Documents
namespace :documents do
  root to: 'documents#index'
end

# Account section
namespace :account do
  resources :experiences, except: [:index, :show]
  resource :personal_data, only: [:edit, :update], controller: 'personal_data'
end
resource :account, only: [:show, :edit, :update], controller: 'account'

# Static pages
get 'terms' => 'pages#terms', as: :terms
get 'privacy-policy' => 'pages#privacy_policy', as: :privacy_policy
get 'cookies-policy' => 'pages#cookies_policy', as: :cookies_policy
get 'data' => 'pages#data', as: :data

get '' => 'home#index', as: :extranet_root
