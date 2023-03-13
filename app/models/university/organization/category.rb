# == Schema Information
#
# Table name: university_organization_categories
#
#  id            :uuid             not null, primary key
#  name          :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  university_id :uuid             not null, indexed
#
# Indexes
#
#  index_university_organization_categories_on_university_id  (university_id)
#
# Foreign Keys
#
#  fk_rails_f610c7eb13  (university_id => universities.id)
#
class University::Organization::Category < ApplicationRecord
  include WithUniversity

  has_and_belongs_to_many :organizations,
                          class_name: 'University::Organization::Category',
                          join_table: :university_organizations_categories,
                          foreign_key: :category_id

  scope :ordered, -> { order(:name) }

  def to_s
    "#{name}"
  end

end
