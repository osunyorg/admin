# Ce modèle concerne les catégories de posts, qui n'ont pas de namespace
# Il pourrait y avoir un namespace, par exemple Blog.
# Si c'était le cas, le modèle devrait être nommé :
# Communication::Website::Permalink::Blog::Category
# Et il faudrait migrer en conséquence
class Communication::Website::Permalink::Category < Communication::Website::Permalink
  def self.required_in_config?(website)
    website.has_blog_posts? && website.has_blog_categories?
  end

  def self.static_config_key
    :posts_categories
  end

  # /actualites/:slug/
  def self.pattern_in_website(website, language)
    "/#{slug_with_ancestors(website, language)}/:slug/"
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
      slug: about.path
    }
  end
end
