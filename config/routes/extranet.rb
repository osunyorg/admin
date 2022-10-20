get 'cohorts' => 'extranet/cohorts#index', as: :education_cohorts
get 'cohorts/:id' => 'extranet/cohorts#show', as: :education_cohort
get 'organizations' => 'extranet/organizations#index', as: :university_organizations
get 'organizations/:id' => 'extranet/organizations#show', as: :university_organization
get 'persons' => 'extranet/persons#index', as: :university_persons
get 'persons/:id' => 'extranet/persons#show', as: :university_person
get 'years' => 'extranet/academic_years#index', as: :education_academic_years
get 'years/:id' => 'extranet/academic_years#show', as: :education_academic_year
get 'account' => 'extranet/account#show', as: :account
get 'account/edit' => 'extranet/account#edit', as: :edit_account
patch 'account' => 'extranet/account#update'
scope :account do
  resources :experiences, controller: 'extranet/experiences', except: [:index, :show]
end
get 'personal_data' => 'extranet/personal_data#show', as: :personal_data
get 'personal_data/edit' => 'extranet/personal_data#edit', as: :edit_personal_data
patch 'personal_data' => 'extranet/personal_data#update'
root to: 'extranet/home#index'
