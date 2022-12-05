class Communication::Website::Permalink::Category < Communication::Website::Permalink
  def self.required_in_config?(website)
    website.has_communication_posts? && website.has_communication_categories?
  end

  def self.static_config_key
    :categories
  end

  # /actualites/:slug/
  def self.pattern_in_website(website)
    "#{website.special_page(:communication_posts).path_without_language}:slug/"
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
