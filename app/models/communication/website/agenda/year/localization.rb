# == Schema Information
#
# Table name: communication_website_agenda_year_localizations
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
#  idx_on_about_id_a91651554e                  (about_id)
#  idx_on_communication_website_id_4d1b373033  (communication_website_id)
#  idx_on_language_id_d451b32d93               (language_id)
#  idx_on_university_id_8ae25517f6             (university_id)
#
# Foreign Keys
#
#  fk_rails_1ef1a9b99c  (about_id => communication_website_agenda_years.id)
#  fk_rails_9c20f2a5c9  (university_id => universities.id)
#  fk_rails_e8dfb6948e  (language_id => languages.id)
#
class Communication::Website::Agenda::Year::Localization < ApplicationRecord
  include AsLocalization
  include Permalinkable
  include WithGitFiles
  include WithUniversity

  belongs_to :website,
              class_name: 'Communication::Website',
              foreign_key: :communication_website_id

  def git_path(website)
    return unless website.id == communication_website_id
    git_path_content_prefix(website) + git_path_relative
  end

  def git_path_relative
    "events/#{slug}/_index.html"
  end

  def template_static
    "admin/communication/websites/agenda/years/static"
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
