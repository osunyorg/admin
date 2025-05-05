# Ce concern ajoute les éléments nécessaires pour les objets indirects :
# - Dépendances et références (avec et via synchro)
# - Connexions (en tant que cible)
module AsIndirectObject
  extend ActiveSupport::Concern

  # Les blocs sont des objets indirects, mais n'ont pas de GitFiles, on n'inclut donc pas HasGitFiles ici
  include WithDependencies

  included do
    has_many  :connections,
              as: :indirect_object,
              class_name: 'Communication::Website::Connection'
              # Pas dependent_destroy parce que le processus est plus sophistiqué, et est fait dans la méthode destroy du WithDependencies
    has_many  :websites,
              -> { distinct },
              through: :connections
    # Ce serait super de faire la ligne ci-dessous, mais Rails ne sait pas faire ça avec un objet polymorphe (direct_source)
    # has_many :direct_sources, through: :connections

    after_save  :connect_to_websites
    after_touch :connect_to_websites
  end

  def is_direct_object?
    false
  end

  def is_indirect_object?
    true
  end

  def for_website?(website)
    website.has_connected_object?(self)
  end

  def references
    if respond_to?(:language)
      direct_sources_localizations_for(language_id)
    else
      direct_sources_localizations
    end
  end

  def direct_sources
    @direct_sources ||= begin
      # On initialise les direct_sources avec les connexions existantes
      direct_sources = direct_sources_from_existing_connections
      # On boucle sur les références pour récupérer les direct sources manquantes
      references.each do |reference|
        direct_sources += direct_sources_from_reference(reference)
      end
      direct_sources.uniq.compact
    end
  end

  def direct_sources_from_existing_connections
    connections.collect &:direct_source
  end

  def direct_sources_with_dependencies_for_website(website)
    dependencies = []
    direct_sources.each do |direct_source|
      dependencies = add_direct_source_to_dependencies(direct_source, website, array: dependencies)
    end
    dependencies
  end

  def connect_to_websites_safely
    previous_direct_sources = direct_sources_from_existing_connections
    direct_sources.each do |direct_source|
      direct_source.website.connect self, direct_source
    end
    new_direct_sources = direct_sources - previous_direct_sources
    if new_direct_sources.any? && respond_to?(:localizations)
      localizations.find_each(&:touch)
    end
  end

  protected

  def direct_sources_localizations
    direct_sources_from_existing_connections.collect(&:localizations).flatten
  end

  def direct_sources_localizations_for(language_id)
    direct_sources_localizations.select { |l10n| l10n.language_id == language_id }
  end

  def direct_sources_from_reference(reference)
    # Early-return to ignore contexts without connections (ex: extranets)
    return [] unless reference.respond_to?(:is_direct_object?)
    reference.is_direct_object? ? [reference] # Récupération de la connexion directe
                                : reference.direct_sources_from_existing_connections # Récupération via les connexions des références

  end

  def connect_to_websites
    Communication::Website::IndirectObject::ConnectToWebsitesJob.perform_later self
  end

  def add_direct_source_to_dependencies(direct_source, website, array: [])
    # Ne pas traiter les sources d'autres sites
    return array unless direct_source.website.id == website.id
    # Ne pas traiter les sources non synchronisables
    return array unless direct_source.syncable?
    # Ne pas traiter si la source directe est déjà dans le tableau de dépendances
    return array if array.include?(direct_source)
    array << direct_source
    # On passe le tableau de dépendances à la méthode recursive_dependencies
    # pour qu'il soit capable d'early return en cas de doublon
    array = direct_source.recursive_dependencies(array: array, syncable_only: true)
    # On ne synchronise pas les références de l'objet direct, car on ne le modifie pas lui.
    array
  end

end