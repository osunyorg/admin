module University::WithPeopleAndOrganizations
  extend ActiveSupport::Concern

  included do
    has_many  :people,
              class_name: 'University::Person',
              dependent: :destroy
    has_many  :organizations,
              class_name: 'University::Organization',
              dependent: :destroy
    has_many  :organization_imports,
              class_name: 'University::Organization::Import',
              dependent: :destroy
    has_many :person_alumnus_imports,
              class_name: 'University::Person::Alumnus::Import',
              dependent: :destroy
  end
end
