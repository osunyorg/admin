# == Schema Information
#
# Table name: imports
#
#  id                :uuid             not null, primary key
#  kind              :integer
#  number_of_lines   :integer
#  processing_errors :jsonb
#  status            :integer          default("pending")
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  language_id       :uuid             not null, indexed
#  university_id     :uuid             not null, indexed
#  user_id           :uuid             indexed
#
# Indexes
#
#  index_imports_on_language_id    (language_id)
#  index_imports_on_university_id  (university_id)
#  index_imports_on_user_id        (user_id)
#
# Foreign Keys
#
#  fk_rails_42cc64a226  (university_id => universities.id)
#  fk_rails_b1e2154c26  (user_id => users.id)
#  fk_rails_b49a015b11  (language_id => languages.id)
#
class Import < ApplicationRecord
  include Filterable

  belongs_to :university
  belongs_to :language
  belongs_to :user, optional: true

  has_one_attached_deletable :file

  enum :kind, { organizations: 0, alumni_cohorts: 1, people_experiences: 2, people: 3 }, prefix: :kind
  enum :status, { pending: 0, finished: 1, finished_with_errors: 2 }

  validate :file_validation

  before_validation :fallback_language_to_university_default, on: :create, unless: :language_id

  after_create :queue_for_processing
  after_commit :send_mail_to_creator, on: :update, if: :status_changed_from_pending?

  scope :for_status, -> (status, language = nil) { where(status: status) }
  scope :ordered, -> (language = nil) { order('created_at DESC') }

  def to_s
    I18n.l created_at, format: :date_with_hour
  end

  def status_class
    return 'text-danger' if finished_with_errors?
    return 'text-info' if finished?
    return ''
  end

  # Setter to serialize data as JSON
  def processing_errors=(value)
    value = JSON.parse value if value.is_a? String
    super(value)
  end

  def url_pattern
    case kind
    when 'organizations', 'people_experiences', 'people'
      "admin_university_#{kind}_import_url"
    when 'alumni_cohorts'
      "admin_administration_#{kind}_import_url"
    end
  end

  private

  def file_validation
    if file.attached?
      unless file.blob.content_type == 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
        file.purge if persisted?
        errors.add(:file, :incorrect_type)
      end
    else
      errors.add(:file, :no_file)
    end
  end

  def queue_for_processing
    Importer::ExecuteJob.perform_later(self)
  end

  def send_mail_to_creator
    NotificationMailer.import(self).deliver_later
  end

  def status_changed_from_pending?
    saved_change_to_status? && status_before_last_save == 'pending'
  end

  def fallback_language_to_university_default
    self.language_id ||= university.default_language_id
  end

end
