module University::Person::WithRoles
  extend ActiveSupport::Concern

  included do
    has_many                :involvements_as_administrator,
                            -> { where(kind: 'administrator') },
                            class_name: 'University::Person::Involvement',
                            dependent: :destroy

    has_many                :roles_as_administrator,
                            through: :involvements_as_administrator,
                            source: :target,
                            source_type: "University::Role"
  end
end
