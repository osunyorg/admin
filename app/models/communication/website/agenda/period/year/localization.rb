# == Schema Information
#
# Table name: communication_website_agenda_period_year_localizations
#
#  id                       :uuid             not null, primary key
#  deleted_at               :datetime
#  slug                     :string
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  about_id                 :uuid             indexed, uniquely indexed => [language_id]
#  communication_website_id :uuid             indexed
#  language_id              :uuid             uniquely indexed => [about_id], indexed
#  university_id            :uuid             indexed
#
# Indexes
#
#  idx_on_about_id_9d0e59880a                  (about_id)
#  idx_on_about_id_language_id_65b759f0dd      (about_id,language_id) UNIQUE
#  idx_on_communication_website_id_ccc9a47ea5  (communication_website_id)
#  idx_on_language_id_bfc0e09bd9               (language_id)
#  idx_on_university_id_22e1603ccb             (university_id)
#
# Foreign Keys
#
#  fk_rails_1ef1a9b99c  (about_id => communication_website_agenda_period_years.id)
#  fk_rails_9c20f2a5c9  (university_id => universities.id)
#  fk_rails_e8dfb6948e  (language_id => languages.id)
#
class Communication::Website::Agenda::Period::Year::Localization < ApplicationRecord
  include AsLocalization
  include Permalinkable
  include HasGitFiles
  include WithUniversity

  belongs_to  :website,
              class_name: 'Communication::Website',
              foreign_key: :communication_website_id

  delegate :value, to: :about

  def git_path_relative
    "events/#{slug}/_index.html"
  end

  def should_sync_to?(website)
    website.id == communication_website_id &&
    website.active_language_ids.include?(language_id) &&
    events_count > 0 # Some events
  end

  def template_static
    "admin/communication/websites/agenda/periods/years/static"
  end

  def months
    about.months.map { |month| month.localized_in(language) }
  end

  def days
    about.days.map { |day| day.localized_in(language) }
  end

  def next
    about.next&.localized_in(language)
  end

  def previous
    about.previous&.localized_in(language)
  end

  def events_count
    unordered_days = Communication::Website::Agenda::Period::Day::Localization.where(
      about_id: about.days.pluck(:id),
      language: language,
      university: university
    )
    unordered_days.sum(:events_count)
  end

  # 25
  def last_two_digits
    to_s.last(2)
  end

  # 2025
  def to_s
    "#{about.value}"
  end

  protected

  # Slugs are the year: "2025"
  # There are no problems with the duplication
  def skip_slug_validation?
    true
  end

  # Override from Permalinkable/Sluggable
  def set_slug
    self.slug = about.value
  end
end
