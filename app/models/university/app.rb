# == Schema Information
#
# Table name: university_apps
#
#  id            :uuid             not null, primary key
#  name          :string
#  token         :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  university_id :uuid             not null, indexed
#
# Indexes
#
#  index_university_apps_on_university_id  (university_id)
#
# Foreign Keys
#
#  fk_rails_2d07655e23  (university_id => universities.id)
#
class University::App < ApplicationRecord
  include WithUniversity

  scope :ordered, -> { order(:name) }

  before_validation :generate_token

  def to_s
    "#{name}"
  end

  protected

  def generate_token
    self.token = SecureRandom.uuid if self.token.blank?
  end
end
