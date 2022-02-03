module University::Person::WithEducation
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
  end

  def education_programs_as_administrator
    university.education_programs
              .joins(:involvements_through_roles)
              .where(university_person_involvements: { person_id: id })
              .distinct
  end
end
