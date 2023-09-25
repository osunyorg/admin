# == Schema Information
#
# Table name: university_apps
#
#  id                  :uuid             not null, primary key
#  name                :string
#  token               :string           indexed
#  token_was_displayed :boolean          default(FALSE)
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  university_id       :uuid             not null, indexed
#
# Indexes
#
#  index_university_apps_on_token          (token) UNIQUE
#  index_university_apps_on_university_id  (university_id)
#
# Foreign Keys
#
#  fk_rails_2d07655e23  (university_id => universities.id)
#
class University::App < ApplicationRecord
  TOKEN_LENGTH = 30

  include WithUniversity

  validates :token, uniqueness: true

  before_validation :generate_token

  scope :ordered, -> { order(:name) }

  def regenerate_token!
    update(token: nil, token_was_displayed: false)
  end

  def to_s
    "#{name}"
  end

  protected

  def generate_token
    self.token = SecureRandom.base64(TOKEN_LENGTH) if self.token.blank?
  end
end
