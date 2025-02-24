class Communication::Website::Permalink::Page::Category < Communication::Website::Permalink
  def self.required_in_config?(website)
    true
  end

  def self.static_config_key
    :pages_categories
  end

  # /:slug/
  def self.pattern_in_website(website, language, about = nil)
    '/:slug/'
  end

  def self.special_page_type
    Communication::Website::Page::Home
  end

  protected

  def published?
    website.id == about.communication_website_id
  end

  def substitutions
    {
      slug: about.slug_with_ancestors_slugs
    }
  end

end
