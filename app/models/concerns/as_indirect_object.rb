# Ce concern ajoute les éléments nécessaires pour les objets indirects :
# - connexions
# - dépendances (avec et via synchro)
# - références nécessaires
module AsIndirectObject
  extend ActiveSupport::Concern

  included do
    # Les blocs sont des objets indirects, mais n'ont pas de GitFiles, on n'inclut donc pas WithGitFiles ici
    include WithDependencies
    include WithReferences

    has_many  :connections,
              as: :indirect_object,
              class_name: 'Communication::Website::Connection'
              # Pas dependent_destroy parce que le processus est plus sophistiqué, et est fait dans la méthode destroy du WithDependencies
    has_many  :websites,
              -> { distinct },
              through: :connections
    # Ce serait super de faire la ligne ci-dessous, mais Rails ne sait pas faire ça avec un objet polymorphe (direct_source)
    # has_many :direct_sources, through: :connections

    after_save  :connect_and_sync_direct_sources
    after_touch :connect_and_sync_direct_sources
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

  def connect_and_sync_direct_sources_safely
    direct_sources.each do |direct_source|
      direct_source.website.connect self, direct_source
    end
    websites.each do |website|
      Communication::Website::IndirectObject::SyncWithGitJob.perform_later(website.id, indirect_object: self)
    end
  end

  protected

  def direct_sources_from_reference(reference)
    # Early-return to ignore contexts without connections (ex: extranets)
    return [] unless reference.respond_to?(:is_direct_object?)
    reference.is_direct_object? ? [reference] # Récupération de la connexion directe
                                : reference.direct_sources_from_existing_connections # Récupération via les connexions des références

  end

  def connect_and_sync_direct_sources
    Communication::Website::IndirectObject::ConnectAndSyncDirectSourcesJob.perform_later self
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