class Communication::Website::Permalink::Post < Communication::Website::Permalink
  def self.required_in_config?(website)
    website.has_blog_posts?
  end

  def self.static_config_key
    :posts
  end

  # /actualites/2022-10-21-un-article/
  def self.pattern_in_website(website, language)
    "/#{special_page_path(website, language)}/:year-:month-:day-:slug/"
  end

  def self.special_page_type
    Communication::Website::Page::CommunicationPost
  end

  protected

  def published?
    website.id == about.communication_website_id && about.published && about.published_at
  end

  def substitutions
    {
      year: about.published_at.strftime("%Y"),
      month: about.published_at.strftime("%m"),
      day: about.published_at.strftime("%d"),
      slug: about.slug
    }
  end
end
