class Communication::Website::Permalink::Author < Communication::Website::Permalink
  def self.required_in_config?(website)
    # website might have authors but no posts (if a post unpublished exists)
    website.has_authors? && website.has_blog_posts?
  end

  def self.static_config_key
    :authors
  end

  # /equipe/:slug/actualites/
  def self.pattern_in_website(website, language)
    "/#{slug_with_ancestors(website, language)}/:slug/#{website.special_page(Communication::Website::Page::CommunicationPost, language: language).slug}/"
  end

  def special_page_type
    Communication::Website::Page::Person
  end
end
