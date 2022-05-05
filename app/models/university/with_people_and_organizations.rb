module University::WithPeopleAndOrganizations
  extend ActiveSupport::Concern

  included do
    has_many  :university_people,
              class_name: 'University::Person',
              dependent: :destroy
    alias_attribute :people, :university_people

    has_many  :university_organizations,
              class_name: 'University::Organization',
              dependent: :destroy
    alias_attribute :organizations, :university_organizations

    has_many  :university_organization_imports,
              class_name: 'University::Organization::Import',
              dependent: :destroy
    alias_attribute :organization_imports, :university_organization_imports

    has_many :university_person_alumnus_imports,
              class_name: 'University::Person::Alumnus::Import',
              dependent: :destroy
    alias_attribute :person_alumnus_imports, :university_person_alumnus_imports
    alias_attribute :alumnus_imports, :university_person_alumnus_imports

    has_many :university_person_experiences,
              class_name: "University::Person::Experience",
              dependent: :destroy
  end
end
