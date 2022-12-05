class Communication::Website::Permalink::Author < Communication::Website::Permalink
  def self.required_for_website?(website)
    # website might have authors but no communication_posts (if a post unpublished exists)
    website.has_authors? && website.has_communication_posts?
  end

  def self.static_config_key
    :authors
  end

  def self.pattern_in_website(website)
    "#{website.special_page(:persons).path_without_language}:slug/#{website.special_page(:communication_posts).slug}/"
  end

  protected

  def published?
    about.for_website?(website)
  end

  def computed_path
    pattern.gsub(":slug", about.slug)
  end
end
