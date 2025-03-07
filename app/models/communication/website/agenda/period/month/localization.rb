# == Schema Information
#
# Table name: communication_website_agenda_period_month_localizations
#
#  id                       :uuid             not null, primary key
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
#  idx_on_about_id_e3d3e69fcb                  (about_id)
#  idx_on_communication_website_id_2202f6cc51  (communication_website_id)
#  idx_on_language_id_8b9b18a131               (language_id)
#  idx_on_university_id_a6d1f20f5d             (university_id)
#
# Foreign Keys
#
#  fk_rails_13625949f9  (language_id => languages.id)
#  fk_rails_ae31731b91  (about_id => communication_website_agenda_period_months.id)
#  fk_rails_f7d0b8f0e9  (university_id => universities.id)
#
class Communication::Website::Agenda::Period::Month::Localization < ApplicationRecord
  include AsLocalization
  include Permalinkable
  include WithGitFiles
  include WithUniversity

  belongs_to  :website,
              class_name: 'Communication::Website',
              foreign_key: :communication_website_id

  delegate :value, to: :about

  def git_path(website)
    return unless website.id == communication_website_id
    git_path_content_prefix(website) + git_path_relative
  end

  def git_path_relative
    "events/#{year.slug}/#{slug}/_index.html"
  end

  def template_static
    "admin/communication/websites/agenda/periods/months/static"
  end

  def to_month_name
    I18n.t("date.month_names", locale: language.iso_code)[about.value].titleize
  end

  def to_month_and_year
    "#{to_month_name} #{year}"
  end

  def year
    about.year.localized_in(language)
  end

  def days
    about.days.map { |day| day.localized_in(language) }
  end

  def to_s
    I18n.localize(about.first_day, locale: language.iso_code, format: '%m')
  end

  protected

  # Override from Permalinkable/Sluggable
  def skip_slug_validation?
    true
  end

  # Override from Permalinkable/Sluggable
  def set_slug
    self.slug = about.value < 10 ? "0#{about.value}" : about.value
  end
end
