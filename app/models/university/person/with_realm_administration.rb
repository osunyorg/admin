module University::Person::WithRealmAdministration
  extend ActiveSupport::Concern

  included do
    has_many  :involvements_as_administrator,
              -> { where(kind: 'administrator') },
              class_name: 'University::Person::Involvement',
              dependent: :destroy

    has_many  :roles_as_administrator,
              through: :involvements_as_administrator,
              source: :target,
              source_type: 'University::Role'

    has_many  :education_programs_as_administrator,
              -> { distinct },
              through: :roles_as_administrator,
              source: :target,
              source_type: 'Education::Program'
  end
end