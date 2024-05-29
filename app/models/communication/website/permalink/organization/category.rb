class Communication::Website::Permalink::Organization::Category < Communication::Website::Permalink
  def self.required_in_config?(website)
    website.has_organizations?
  end

  def self.static_config_key
    :organizations_categories
  end

  # /organisations/:slug/
  def self.pattern_in_website(website, language)
    "/#{slug_with_ancestors(website, language)}/:slug/"
  end

  def self.special_page_type
    Communication::Website::Page::Organization
  end

  protected

  def substitutions
    {
      slug: about.slug
    }
  end

end
