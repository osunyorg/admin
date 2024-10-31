module University::Person::WithRealmEducation
  extend ActiveSupport::Concern

  included do
    has_many  :involvements_as_teacher,
              -> { where(kind: 'teacher') },
              class_name: 'University::Person::Involvement',
              dependent: :destroy

    has_many  :education_programs_as_teacher,
              through: :involvements_as_teacher,
              source: :target,
              source_type: "Education::Program"

    has_many  :teacher_websites,
              -> { distinct },
              through: :education_programs,
              source: :websites
  end
end
