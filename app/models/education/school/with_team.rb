module Education::School::WithTeam
  extend ActiveSupport::Concern

  included do
    has_many    :university_roles,
                class_name: 'University::Role',
                as: :target,
                dependent: :destroy

    has_many    :involvements_through_roles,
                through: :university_roles,
                source: :involvements

    has_many    :university_people_through_role_involvements,
                through: :involvements_through_roles,
                source: :person

    has_many    :university_people_through_program_involvements,
                through: :programs,
                source: :university_people_through_involvements

    has_many    :university_people_through_program_role_involvements,
                through: :programs,
                source: :university_people_through_role_involvements

    has_many    :university_people_through_published_program_involvements,
                through: :published_programs,
                source: :university_people_through_involvements

    has_many    :university_people_through_published_program_role_involvements,
                through: :published_programs,
                source: :university_people_through_role_involvements
  end

  def researchers
    people_ids = (
      university_people_through_published_program_involvements +
      university_people_through_role_involvements +
      university_people_through_published_program_role_involvements
    ).pluck(:id)
    university.people.where(id: people_ids, is_researcher: true)
  end

  def teachers
    people_ids = university_people_through_published_program_involvements.pluck(:id)
    university.people.where(id: people_ids, is_teacher: true)
  end

  def administrators
    people_ids = (
      university_people_through_role_involvements +
      university_people_through_published_program_role_involvements
    ).pluck(:id)
    university.people.where(id: people_ids, is_administration: true)
  end


  def has_administrators?
    university_people_through_role_involvements.any? ||
    university_people_through_program_role_involvements.any?
  end

  def has_researchers?
    researchers.any?
  end

  def has_teachers?
    teachers.any?
  end
end
