# == Schema Information
#
# Table name: communication_extranet_files
#
#  id            :uuid             not null, primary key
#  name          :string
#  published     :boolean
#  published_at  :datetime
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  extranet_id   :uuid             not null, indexed
#  university_id :uuid             not null, indexed
#
# Indexes
#
#  index_communication_extranet_files_on_extranet_id    (extranet_id)
#  index_communication_extranet_files_on_university_id  (university_id)
#
# Foreign Keys
#
#  fk_rails_1272fd263c  (extranet_id => communication_extranets.id)
#  fk_rails_af877a8c0c  (university_id => universities.id)
#
class Communication::Extranet::File < ApplicationRecord
  include Sanitizable
  include WithUniversity

  belongs_to :extranet, class_name: 'Communication::Extranet'

  validates :name, presence: true

  before_validation :set_published_at

  scope :published, -> { where(published: true) }
  scope :ordered, -> { order(published_at: :desc) }

  def to_s
    "#{name}"
  end

  protected

  def set_published_at
    self.published_at = Time.zone.now if published && published_at.nil?
  end
end
