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
  end

end
