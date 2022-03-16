get 'organizations'     => 'extranet/organizations#index', as: :organizations
get 'organization/:id'  => 'extranet/organizations#show', as: :university_organization
get 'years'             => 'extranet/academic_years#index', as: :academic_years
get 'years/:id'         => 'extranet/academic_years#show', as: :academic_year
