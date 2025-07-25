class Communication::Website::Permalink::Page < Communication::Website::Permalink

  # /notre-institut/histoire/
  def self.pattern_in_website(website, language, about = nil)
    '/:slug/'
  end

  protected

  def substitutions
    {
      slug: about.slug_with_ancestors_slugs
    }
  end

end
