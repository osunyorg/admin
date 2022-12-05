class Communication::Website::Permalink::Post < Communication::Website::Permalink
  def self.required_for_website?(website)
    website.has_communication_posts?
  end

  def self.static_config_key
    :posts
  end

  # /actualites/2022/10/21/un-article/
  # Pas de /fr au début, parce qu'Hugo a besoin du permalink sans langue
  def self.pattern_in_website(website)
    "#{website.special_page(:communication_posts).path_without_language}:year/:month/:day/:slug/"
  end

  protected

  def published?
    website.id == about.communication_website_id && about.published && about.published_at
  end

  def substitutions
    {
      year: about.published_at.year,
      month: about.published_at.month,
      day: about.published_at.day,
      slug: about.slug
    }
  end
end
