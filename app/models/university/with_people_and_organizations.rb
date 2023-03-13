module University::WithPeopleAndOrganizations
  extend ActiveSupport::Concern

  included do
    has_many  :university_people,
              class_name: 'University::Person',
              dependent: :destroy
    alias_attribute :people, :university_people

    has_many  :university_people_categories,
              class_name: 'University::Person::Category',
              dependent: :destroy
    alias_attribute :people_categories, :university_people_categories

    has_many  :university_organizations,
              class_name: 'University::Organization',
              dependent: :destroy
    alias_attribute :organizations, :university_organizations

    has_many  :university_organizations_categories,
              class_name: 'University::Organization::Category',
              dependent: :destroy
    alias_attribute :organizations_categories, :university_organizations_categories

    has_many  :person_experiences,
              class_name: 'University::Person::Experience',
              dependent: :destroy
    alias_attribute :university_person_experiences, :person_experiences
  end

end
