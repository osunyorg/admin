# == Schema Information
#
# Table name: education_teachers
#
#  id            :uuid             not null, primary key
#  first_name    :string
#  github_path   :text
#  last_name     :string
#  slug          :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  university_id :uuid             not null
#  user_id       :uuid
#
# Indexes
#
#  index_education_teachers_on_university_id  (university_id)
#  index_education_teachers_on_user_id        (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (university_id => universities.id)
#  fk_rails_...  (user_id => users.id)
#
class Education::Teacher < ApplicationRecord
  include WithPublicationToWebsites
  include WithSlug

  has_rich_text :biography

  belongs_to :university
  belongs_to :user, optional: true
  has_and_belongs_to_many :programs,
                          class_name: 'Education::Program',
                          join_table: 'education_programs_teachers',
                          foreign_key: 'education_teacher_id',
                          association_foreign_key: 'education_program_id'
  has_many :websites, -> { distinct }, through: :programs

  scope :ordered, -> { order(:last_name, :first_name) }

  def to_s
    "#{last_name} #{first_name}"
  end

end
