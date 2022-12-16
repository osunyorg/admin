# == Schema Information
#
# Table name: communication_website_permalinks
#
#  id            :uuid             not null, primary key
#  about_type    :string           not null
#  is_current    :boolean          default(TRUE)
#  path          :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  about_id      :uuid             not null
#  university_id :uuid             not null, indexed
#  website_id    :uuid             not null, indexed
#
# Indexes
#
#  index_communication_website_permalinks_on_university_id  (university_id)
#  index_communication_website_permalinks_on_website_id     (website_id)
#
# Foreign Keys
#
#  fk_rails_e9646cce64  (university_id => universities.id)
#  fk_rails_f389ba7d45  (website_id => communication_websites.id)
#
class Communication::Website::Permalink::Person < Communication::Website::Permalink
  def self.required_in_config?(website)
    website.has_persons?
  end

  def self.static_config_key
    :persons
  end

  # /equipe/:slug/
  def self.pattern_in_website(website)
    "#{website.special_page(:persons).path}:slug/"
  end
end
