class Communication::Website::Permalink::Author < Communication::Website::Permalink
  def self.required_in_config?(website)
    # website might have authors but no communication_posts (if a post unpublished exists)
    website.has_authors? && website.has_communication_posts?
  end

  def self.static_config_key
    :authors
  end

  # /equipe/:slug/actualites/
  def self.pattern_in_website(website, language)
    "/#{website.special_page(Communication::Website::Page::Person, language: language).slug_with_ancestors}/:slug/#{website.special_page(Communication::Website::Page::CommunicationPost, language: language).slug}/"
  end
end
