class Communication::Website::Permalink::Person::Category < Communication::Website::Permalink
  def self.required_in_config?(website)
    website.has_persons?
  end

  def self.static_config_key
    :persons_categories
  end

  # /equipe/:slug/
  def self.pattern_in_website(website, language)
    "/#{slug_with_ancestors(website, language)}/:slug/"
  end

  def self.special_page_type
    Communication::Website::Page::Person
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
