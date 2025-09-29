# == Schema Information
#
# Table name: communication_website_permalinks
#
#  id            :uuid             not null, primary key
#  about_type    :string           not null, indexed => [about_id]
#  is_current    :boolean          default(TRUE)
#  path          :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  about_id      :uuid             not null, indexed => [about_type]
#  university_id :uuid             not null, indexed
#  website_id    :uuid             not null, indexed
#
# Indexes
#
#  index_communication_website_permalinks_on_about          (about_type,about_id)
#  index_communication_website_permalinks_on_university_id  (university_id)
#  index_communication_website_permalinks_on_website_id     (website_id)
#
# Foreign Keys
#
#  fk_rails_e9646cce64  (university_id => universities.id)
#  fk_rails_f389ba7d45  (website_id => communication_websites.id)
#
class Communication::Website::Permalink::Agenda::Exhibition < Communication::Website::Permalink
  delegate :exhibition, to: :about

  def self.required_in_config?(website)
    website.feature_agenda
  end

  def self.static_config_key
    :exhibitions
  end

  # /expositions/2022-10-21-pulse/
  def self.pattern_in_website(website, language, about = nil)
    special_page_path(website, language) + '/:year-:month-:day-:slug:federation_suffix/'
  end

  def self.special_page_type
    Communication::Website::Page::CommunicationAgendaExhibition
  end

  protected

  def substitutions
    {
      year: about.from_day.strftime("%Y"),
      month: about.from_day.strftime("%m"),
      day: about.from_day.strftime("%d"),
      slug: about.slug,
      federation_suffix: exhibition.suffix_in(website)
    }
  end

end
