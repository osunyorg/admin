class Communication::Website::Permalink::Organization::Category < Communication::Website::Permalink
  def self.required_in_config?(website)
    website.has_organizations?
  end

  def self.static_config_key
    :organizations_categories
  end

  # /organisations/:slug/
  def self.pattern_in_website(website, language)
    "/#{website.special_page(Communication::Website::Page::Organization, language: language).slug_with_ancestors}/:slug/"
  end

  protected

  def published?
    website.id == about.communication_website_id
  end

  def substitutions
    {
      slug: about.slug
    }
  end

end
