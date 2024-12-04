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

  # Le permalink tel que mentionné dans les statics, dans la clé `url``
  # Ex: "/agenda/2024-11-27-communs-numerique-et-interet-general/"
  # Il y a un slash au début et à la fin, et la langue si elle existe 
  def hugo_permalink_in_website(website)
    "#{current_permalink_in_website(website)&.path}"
  end

  # L'identifiant Hugo
  # Ex: /events/2024-12-27-communs-numerique-et-interet-general
  # https://gohugo.io/methods/page/path/
  # 1. Strips the file extension
  # 2. Strips the language identifier
  # 3. Converts the result to lower case
  # 4. Replaces spaces with hyphens
  def hugo_path_in_website(website)
    # Filename
    path = "#{hugo_file_in_website(website)}"
    # Strip /content/fr
    path.delete_prefix!(git_path_content_prefix(website))
    path.delete_suffix!('/_index.html')
    path.delete_suffix!('.html')
    path = "/#{path}" unless path.start_with?('/')
    path
  end

  # Le chemin physique du fichier
  # Ex: content/fr/events/2024-12-27-communs-numerique-et-interet-general.html
  def hugo_file_in_website(website)
    git_path(website)
  end

  # Le slug pur, tel qu'enregistré dans la base de données
  # Ex: communs-numerique-et-interet-general
  def hugo_slug_in_website(website)
    slug
  end
end