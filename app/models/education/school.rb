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
  belongs_to :university
  has_one :website, class_name: 'Communication::Website', foreign_key: :about
  has_and_belongs_to_many :programs,
                          class_name: 'Education::Program',
                          join_table: 'education_programs_schools',
                          foreign_key: 'education_school_id',
                          association_foreign_key: 'education_program_id'

  validates :name, :address, :city, :zipcode, :country, presence: true

  scope :ordered, -> { order(:name) }

  def to_s
    "#{name}"
  end
end
