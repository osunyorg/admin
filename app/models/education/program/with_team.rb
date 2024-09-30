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

  def administrators
    people_ids = (
      university_people_through_role_involvements +
      descendants.collect(&:university_people_through_role_involvements).flatten
    ).pluck(:id)
    university.people.where(id: people_ids, is_administration: true)
  end

  def teachers
    people_ids = (
      university_people_through_involvements +
      descendants.collect(&:university_people_through_involvements).flatten
    ).pluck(:id)
    university.people.where(id: people_ids, is_teacher: true)
  end

  def has_administrators?
    university_people_through_role_involvements.any? ||
    descendants.any? { |descendant| descendant.university_people_through_role_involvements.any? }
  end

  def has_researchers?
    false
  end

  def has_teachers?
    university_people_through_involvements.any? ||
    descendants.any? { |descendant| descendant.university_people_through_involvements.any? }
  end
end
