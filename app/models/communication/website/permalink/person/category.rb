class Communication::Website::Permalink::Person::Category < Communication::Website::Permalink
  def self.required_in_config?(website)
    website.has_persons?
  end

  def self.static_config_key
    :persons_categories
  end

  # /equipe/categories/:slug/
  def self.pattern_in_website(website, language)
    special_page_path(website, language) + '/categories/:slug/'
  end

  def self.special_page_type
    Communication::Website::Page::Person
  end

  protected

  def substitutions
    {
      slug: about.slug_with_ancestors_slugs
    }
  end

end
