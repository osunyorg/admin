module Education::Program::WithTeam
  extend ActiveSupport::Concern

  included do
    has_many   :university_roles,
               class_name: 'University::Role',
               as: :target,
               dependent: :destroy

    has_many   :involvements_through_roles,
               through: :university_roles,
               source: :involvements

    has_many   :university_people_through_role_involvements,
               through: :involvements_through_roles,
               source: :person

    has_many   :university_person_involvements,
               class_name: 'University::Person::Involvement',
               as: :target,
               inverse_of: :target,
               dependent: :destroy

    accepts_nested_attributes_for :university_person_involvements,
                                  reject_if: :all_blank,
                                  allow_destroy: true

    has_many   :university_people_through_involvements,
               through: :university_person_involvements,
               source: :person
  end
end
