# == Schema Information
#
# Table name: communication_website_agenda_period_year_localizations
#
#  id                       :uuid             not null, primary key
#  events_count             :integer          default(0)
#  slug                     :string
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  about_id                 :uuid             indexed
#  communication_website_id :uuid             indexed
#  language_id              :uuid             indexed
#  university_id            :uuid             indexed
#
# Indexes
#
#  idx_on_about_id_9d0e59880a                  (about_id)
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
  include Communication::Website::Agenda::Period::BaseLocalization
  include Permalinkable
  include WithGitFiles
  include WithUniversity

  def git_path(website)
    return unless website.id == communication_website_id
    git_path_content_prefix(website) + git_path_relative
  end

  def git_path_relative
    "events/#{slug}/_index.html"
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

  def events
    @events ||= website.events.on_year(value)
  end

  def time_slots
    @time_slots ||= website.time_slots.on_year(value)
  end

  # 25
  def last_two_digits
    to_s.last(2)
  end

  # 2025
  def to_s
    "#{about.value}"
  end
end
