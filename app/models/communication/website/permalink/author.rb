class Communication::Website::Permalink::Author < Communication::Website::Permalink
  def self.required_in_config?(website)
    website.has_authors? && website.feature_posts
  end

  def self.static_config_key
    :authors
  end

  # /equipe/:slug/actualites/
  def self.pattern_in_website(website, language)
    posts_page = website.special_page(Communication::Website::Page::CommunicationPost)
    posts_page_l10n = posts_page.best_localization_for(language)
    special_page_path(website, language) + "/:slug/#{posts_page_l10n.slug}/"
  end

  def self.special_page_type
    Communication::Website::Page::Person
  end
end
