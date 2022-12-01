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
  include WithPrograms # must come before WithAlumni and WithTeam
  include WithTeam
  include WithAlumni

  belongs_to  :university

  has_many    :websites,
              class_name: 'Communication::Website',
              as: :about,
              dependent: :nullify

  has_one_attached_deletable :logo

  validates :name, :address, :city, :zipcode, :country, presence: true

  scope :ordered, -> { order(:name) }
  scope :for_search_term, -> (term) {
    where("
      unaccent(education_schools.address) ILIKE unaccent(:term) OR
      unaccent(education_schools.city) ILIKE unaccent(:term) OR
      unaccent(education_schools.country) ILIKE unaccent(:term) OR
      unaccent(education_schools.name) ILIKE unaccent(:term) OR
      unaccent(education_schools.phone) ILIKE unaccent(:term) OR
      unaccent(education_schools.zipcode) ILIKE unaccent(:term)
    ", term: "%#{sanitize_sql_like(term)}%")
  }
  scope :for_program, -> (program_id) {
    joins(:programs).where(education_programs: { id: program_id })
  }

  def to_s
    "#{name}"
  end

  def git_path(website)
    "data/school.yml"
  end

  def git_dependencies(website)
    dependencies = [self]
    dependencies += programs +
                    programs.map(&:active_storage_blobs).flatten
    dependencies += diplomas
    dependencies += teachers +
                    teachers.map(&:teacher) +
                    teachers.map(&:active_storage_blobs).flatten
    dependencies += researchers +
                    researchers.map(&:researcher) +
                    researchers.map(&:active_storage_blobs).flatten
    dependencies += administrators +
                    administrators.map(&:administrator) +
                    administrators.map(&:active_storage_blobs).flatten
    dependencies
  end

  #####################
  # Aboutable methods #
  #####################

  def has_research_papers?
    false
  end

  def has_research_volumes?
    false
  end
end
