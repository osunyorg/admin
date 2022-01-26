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
#  university_id :uuid             not null
#
# Indexes
#
#  index_education_schools_on_university_id  (university_id)
#
# Foreign Keys
#
#  fk_rails_...  (university_id => universities.id)
#
class Education::School < ApplicationRecord
  include WithGit

  belongs_to :university
  has_many  :websites, class_name: 'Communication::Website', as: :about, dependent: :nullify
  has_many  :administrators, dependent: :destroy
  has_many  :university_people_through_administrators,
            through: :administrators,
            source: :person
  has_many  :university_roles, class_name: 'University::Role', as: :target, dependent: :destroy
  has_many  :university_people_through_roles,
            through: :university_roles,
            source: :person
  has_and_belongs_to_many :programs,
                          class_name: 'Education::Program',
                          join_table: 'education_programs_schools',
                          foreign_key: 'education_school_id',
                          association_foreign_key: 'education_program_id'
  has_many :teachers, -> { distinct }, through: :programs

  validates :name, :address, :city, :zipcode, :country, presence: true

  scope :ordered, -> { order(:name) }

  def to_s
    "#{name}"
  end

  def git_path(website)
    "data/school.yml"
  end

  def git_dependencies(website)
    [self] +
    university_people_through_administrators +
    university_people_through_administrators.map(&:administrator)
  end
end
