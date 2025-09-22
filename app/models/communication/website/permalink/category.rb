# Ce modèle concerne les catégories de posts, qui n'ont pas de namespace
# Il pourrait y avoir un namespace, par exemple Blog.
# Si c'était le cas, le modèle devrait être nommé :
# Communication::Website::Permalink::Blog::Category
# Et il faudrait migrer en conséquence
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
class Communication::Website::Permalink::Category < Communication::Website::Permalink
  def self.required_in_config?(website)
    website.feature_posts
  end

  def self.static_config_key
    :posts_categories
  end

  # /actualites/:slug/
  # Le slug est en fait un assemblage des ancêtres, comme :
  # /actualites/categorie-parente-categorie-enfant/
  def self.pattern_in_website(website, language, about = nil)
    special_page_path(website, language) + '/:slug/'
  end

  def self.special_page_type
    Communication::Website::Page::CommunicationPost
  end

  protected

  def substitutions
    {
      slug: about.slug_with_published_ancestors_slugs
    }
  end

end
