# == Schema Information
#
# Table name: university_roles
#
#  id            :uuid             not null, primary key
#  position      :integer          not null
#  target_type   :string           indexed => [target_id]
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  target_id     :uuid             indexed => [target_type]
#  university_id :uuid             not null, indexed
#
# Indexes
#
#  index_university_roles_on_target         (target_type,target_id)
#  index_university_roles_on_university_id  (university_id)
#
# Foreign Keys
#
#  fk_rails_8e52293a38  (university_id => universities.id)
#
class University::Role < ApplicationRecord
  include Localizable
  include Orderable
  include WithUniversity

  # Can be an Education::School or an Education::Program
  belongs_to :target, polymorphic: true, optional: true
  has_many :involvements, class_name: 'University::Person::Involvement', as: :target, dependent: :destroy, inverse_of: :target
  has_many :people, through: :involvements

  accepts_nested_attributes_for :involvements, reject_if: :all_blank, allow_destroy: true

  protected

  def last_ordered_element
    self.class.unscoped.where(university_id: university_id, target: target).ordered.last
  end

end
