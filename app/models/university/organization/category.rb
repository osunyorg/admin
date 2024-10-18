# == Schema Information
#
# Table name: university_organization_categories
#
#  id            :uuid             not null, primary key
#  position      :integer          default(0)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  parent_id     :uuid             indexed
#  university_id :uuid             not null, indexed
#
# Indexes
#
#  index_university_organization_categories_on_parent_id      (parent_id)
#  index_university_organization_categories_on_university_id  (university_id)
#
# Foreign Keys
#
#  fk_rails_e24342b62d  (parent_id => university_organization_categories.id)
#  fk_rails_f610c7eb13  (university_id => universities.id)
#
class University::Organization::Category < ApplicationRecord
  include AsIndirectObject
  include Localizable
  include Orderable
  include WithTree
  include WithUniversity

  belongs_to :parent,
             class_name: 'University::Organization::Category',
             optional: true
  has_many   :children,
             class_name: 'University::Organization::Category',
             foreign_key: :parent_id,
             dependent: :destroy
  has_and_belongs_to_many :organizations,
                          class_name: 'University::Organization',
                          join_table: :university_organizations_categories

  def dependencies
    localizations
  end

  def references
    organizations
  end

end
