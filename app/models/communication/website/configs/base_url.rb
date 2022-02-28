# == Schema Information
#
# Table name: communication_websites
#
#  id                                :uuid             not null, primary key
#  about_type                        :string           indexed => [about_id]
#  access_token                      :string
#  git_endpoint                      :string
#  git_provider                      :integer          default("github")
#  name                              :string
#  repository                        :string
#  static_pathname_administrators    :string           default("administrators")
#  static_pathname_authors           :string           default("authors")
#  static_pathname_posts             :string           default("posts")
#  static_pathname_programs          :string           default("programs")
#  static_pathname_research_articles :string           default("articles")
#  static_pathname_research_volumes  :string           default("volumes")
#  static_pathname_researchers       :string           default("researchers")
#  static_pathname_staff             :string           default("staff")
#  static_pathname_teachers          :string           default("teachers")
#  url                               :string
#  created_at                        :datetime         not null
#  updated_at                        :datetime         not null
#  about_id                          :uuid             indexed => [about_type]
#  university_id                     :uuid             not null, indexed
#
# Indexes
#
#  index_communication_websites_on_about          (about_type,about_id)
#  index_communication_websites_on_university_id  (university_id)
#
# Foreign Keys
#
#  fk_rails_94b0abd85b  (university_id => universities.id)
#
class Communication::Website::Configs::BaseUrl < Communication::Website

  def self.polymorphic_name
    'Communication::Website::Configs::BaseUrl'
  end

  def git_path(website)
    "config/production/config.yaml"
  end

end
