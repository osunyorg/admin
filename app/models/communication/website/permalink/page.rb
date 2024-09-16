class Communication::Website::Permalink::Page < Communication::Website::Permalink

  # /notre-institut/histoire/
  def self.pattern_in_website(website, language)
    '/:slug_with_ancestors_slugs/'
  end

  protected

  def published?
    website.id == about.communication_website_id && about.published
  end

  def substitutions
    {
      slug_with_ancestors_slugs: about.slug_with_ancestors_slugs
    }
  end

  # ##### DEFAULT ######
  # # Can be overwritten (Page for example)
  # def published_path
  #   language = about.respond_to?(:language) ? about.language : website.default_language
  #   p = ""
  #   p += "/#{language.iso_code}" if website.active_languages.many?
  #   p += pattern
  #   substitutions.each do |key, value|
  #     p.gsub! ":#{key}", "#{value}"
  #   end
  #   p
  # end
  # ##### /DEFAULT ######

  # # /notre-institut/histoire/
  # # Pages are special, there is no substitution and no pattern
  # def published_path
  #   about.path
  # end

  # ##### PAGE LOC WITH PATH ######
  # def path
  #   path = ''
  #   if website.active_languages.many?
  #     path += "/#{language.iso_code}"
  #   end
  #   path += "/#{slug_with_ancestors}/"
  #   path.gsub(/\/+/, '/')
  # end
  # ##### /PAGE LOC WITH PATH ######
end
