# == Schema Information
#
# Table name: education_schools
#
#  id            :uuid             not null, primary key
#  address       :string
#  city          :string
#  country       :string
#  latitude      :float
#  longitude     :float
#  name          :string
#  phone         :string
#  zipcode       :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  university_id :uuid             not null, indexed
#
# Indexes
#
#  index_education_schools_on_university_id  (university_id)
#
# Foreign Keys
#
#  fk_rails_e01b37a3ad  (university_id => universities.id)
#
class Education::School < ApplicationRecord
  include WithGit
  include Aboutable

  has_and_belongs_to_many :programs,
                          class_name: 'Education::Program',
                          join_table: 'education_programs_schools',
                          foreign_key: 'education_school_id',
                          association_foreign_key: 'education_program_id'
  belongs_to  :university
  has_many    :websites,
              class_name: 'Communication::Website',
              as: :about,
              dependent: :nullify
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

  validates :name, :address, :city, :zipcode, :country, presence: true

  scope :ordered, -> { order(:name) }

  def to_s
    "#{name}"
  end

  def researchers
    people_ids = (
      university_people_through_program_involvements +
      university_people_through_role_involvements +
      university_people_through_program_role_involvements
    ).pluck(:id)
    university.people.where(id: people_ids, is_researcher: true)
  end

  def git_path(website)
    "data/school.yml"
  end

  def git_dependencies(website)
    [self] +
    university_people_through_role_involvements +
    university_people_through_role_involvements.map(&:administrator) +
    university_people_through_role_involvements.map(&:active_storage_blobs).flatten
  end

  def has_administrators?
    university_people_through_role_involvements.any? ||
    university_people_through_program_role_involvements.any?
  end

  def has_researchers?
    researchers.any?
  end

  def has_teachers?
    university_people_through_program_involvements.any?
  end

  def has_education_programs?
    programs.any?
  end

  def has_research_articles?
    false
  end

  def has_research_volumes?
    false
  end
end
