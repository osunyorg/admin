# == Schema Information
#
# Table name: administration_members
#
#  id                :uuid             not null, primary key
#  first_name        :string
#  is_administrative :boolean
#  is_author         :boolean
#  is_researcher     :boolean
#  is_teacher        :boolean
#  last_name         :string
#  slug              :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  university_id     :uuid             not null
#  user_id           :uuid
#
# Indexes
#
#  index_administration_members_on_university_id  (university_id)
#  index_administration_members_on_user_id        (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (university_id => universities.id)
#  fk_rails_...  (user_id => users.id)
#
class Administration::Member < ApplicationRecord
  include WithSlug

  has_rich_text :biography

  belongs_to :university
  belongs_to :user, optional: true

  scope :ordered, -> { order(:last_name, :first_name) }

  def to_s
    "#{last_name} #{first_name}"
  end
  
end
