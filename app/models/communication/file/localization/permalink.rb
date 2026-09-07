# == Schema Information
#
# Table name: communication_file_localization_permalinks
#
#  id                                 :uuid             not null, primary key
#  is_current                         :boolean
#  path                               :string
#  created_at                         :datetime         not null
#  updated_at                         :datetime         not null
#  communication_file_localization_id :uuid             not null, indexed
#
# Indexes
#
#  idx_on_communication_file_localization_id_d9f5f5a2f8  (communication_file_localization_id)
#
# Foreign Keys
#
#  fk_rails_e23549fca9  (communication_file_localization_id => communication_file_localizations.id)
#
class Communication::File::Localization::Permalink < ApplicationRecord
  belongs_to :communication_file_localization

  scope :ordered, -> { order(created_at: :desc) }
  scope :current, -> { where(is_current: true) }
  scope :not_current, -> { where(is_current: false) }

  after_commit :manage_previous_permalinks

  protected

  def manage_previous_permalinks
    siblings.update_all :is_current, false
  end

  def siblings
    Communication::File::Localization::Permalink.where(
      communication_file_localization_id: id
    ).where.not(
      id: id
    )
  end
end
