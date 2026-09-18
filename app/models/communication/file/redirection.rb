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

  before_validation :set_path

  validate  :path_available
  validates :path, presence: true
  validates :path_without_extension,
            format: {
              with: /\A[a-z0-9\-\/]+\z/,
              message: I18n.t('slug_error')
            }

  def self.add(l10n, path)
    create(
      communication_file_localization_id: l10n.id,
      university_id: l10n.university_id,
      path: path
    )
  end

  def self.remove(university, path)
    where(
      university_id: university.id,
      path: path
    ).destroy_all
  end

  def path_without_extension
    self.path.to_s.delete_suffix extension
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

  def path_available
    taken = self.class
                .unscoped
                .where(
                  university_id: university_id,
                  path: path
                )
                .where.not(id: id)
                .exists?
    errors.add(:path, :taken) if taken
  end

  def set_path
    return if path.present?
    self.path = "/#{@path_without_extension}#{extension}"
  end
end
