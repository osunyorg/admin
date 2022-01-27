# == Schema Information
#
# Table name: university_roles
#
#  id            :uuid             not null, primary key
#  description   :text
#  position      :integer
#  target_type   :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  target_id     :uuid
#  university_id :uuid             not null
#
# Indexes
#
#  index_university_roles_on_target         (target_type,target_id)
#  index_university_roles_on_university_id  (university_id)
#
# Foreign Keys
#
#  fk_rails_...  (university_id => universities.id)
#
class University::Role < ApplicationRecord
  include WithPosition

  belongs_to :university
  belongs_to :target, polymorphic: true, optional: true
  has_many :involvements, class_name: 'University::Person::Involvement', as: :target

  def to_s
    "#{description}"
  end

  def sync_with_git
    target.sync_with_git if target&.respond_to? :sync_with_git
  end

  protected

  def last_ordered_element
    self.class.unscoped.where(university_id: university_id, target: target).ordered.last
  end
end
