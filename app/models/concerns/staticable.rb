module Staticable
  extend ActiveSupport::Concern

  def hugo(website)
    @hugo ||= OpenStruct.new(
      permalink: hugo_permalink_in_website(website),
      path: hugo_path_in_website(website),
      file: hugo_file_in_website(website),
      slug: hugo_slug_in_website(website)
    )
  end

  def hugo_ancestors(website)
    ancestors = []
    ancestors.concat hugo_ancestors_for_special_page(website)
    # Certains objets ont des ancêtres, il faut les lister
    ancestors.concat self.ancestors if respond_to?(:ancestors)
    ancestors.compact
  end

  def hugo_ancestors_and_self(website)
    hugo_ancestors(website) + [self]
  end

  protected

  # Si on est sur une page, pas d'ancêtres à chercher, le breadcrumb va se construire avec les parents.
  # Sinon, les objets ont une "page spéciale", (agenda, actualités, offre de formation...)
  # Cette page a aussi des ancêtres, qu'il faut récupérer avec ancestors_and_self
  def hugo_ancestors_for_special_page(website)
    return [] if is_a?(Communication::Website::Page::Localization)
    permalink = Communication::Website::Permalink.for_object(self, website)
    return [] unless permalink
    special_page = permalink.special_page(website)
    return [] unless special_page
    special_page_l10n = special_page.localization_for(language)
    return [] unless special_page_l10n
    special_page_l10n.ancestors_and_self
  end

  def hugo_permalink_in_website(website)
    "#{current_permalink_in_website(website)&.path}"
  end

  def hugo_path_in_website(website)
    respond_to?(:path) ? path : slug
  end

  def hugo_file_in_website(website)
    git_path(website)
  end

  def hugo_slug_in_website(website)
    slug
  end
end