# Ce modèle concerne les catégories de posts, qui n'ont pas de namespace
# Il pourrait y avoir un namespace, par exemple Blog.
# Si c'était le cas, le modèle devrait être nommé :
# Communication::Website::Permalink::Blog::Category
# Et il faudrait migrer en conséquence
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
  def self.pattern_in_website(website, language)
    "/#{special_page_path(website, language)}/:slug/"
  end

  def self.special_page_type
    Communication::Website::Page::CommunicationPost
  end

  protected

  def published?
    true
  end

  def substitutions
    {
      slug: about.slug_with_ancestors_slugs
    }
  end

end
