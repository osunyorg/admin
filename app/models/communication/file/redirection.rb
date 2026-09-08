# == Schema Information
#
# Table name: communication_file_redirections
#
#  id                                 :uuid             not null, primary key
#  path                               :string
#  created_at                         :datetime         not null
#  updated_at                         :datetime         not null
#  communication_file_localization_id :uuid             not null, indexed
#  university_id                      :uuid             not null, indexed
#
# Indexes
#
#  idx_on_communication_file_localization_id_b5293392d9    (communication_file_localization_id)
#  index_communication_file_redirections_on_university_id  (university_id)
#
# Foreign Keys
#
#  fk_rails_154fa850da  (university_id => universities.id)
#  fk_rails_f6bf714890  (communication_file_localization_id => communication_file_localizations.id)
#
class Communication::File::Redirection < ApplicationRecord
  include HasUniversity

  attr_accessor :path_without_extension

  belongs_to  :communication_file_localization,
              class_name: 'Communication::File::Localization'
  alias       :file_l10n :communication_file_localization

  scope :ordered, -> { order(created_at: :desc) }
  scope :current, -> { where(is_current: true) }
  scope :not_current, -> { where(is_current: false) }

  validates_presence_of :path

  before_validation :set_path

  def path_without_extension
    self.path.delete_suffix extension
  end

  def url
    "#{university.file_server.url}#{path}"
  end

  def extension
    communication_file_localization&.original_extension
  end

  def to_s
    "#{path}"
  end

  protected

  def set_path
    self.path = "/#{@path_without_extension}#{extension}"
  end
end
