class Communication::Website::Permalink::Page < Communication::Website::Permalink

  # /notre-institut/histoire/
  def self.pattern_in_website(website, language)
    '/:slug/'
  end

  protected

  def published?
    website.id == about.communication_website_id && about.published
  end

  def substitutions
    {
      slug: about.slug_with_ancestors_slugs
    }
  end

end
