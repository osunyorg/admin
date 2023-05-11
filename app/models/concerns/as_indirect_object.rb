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
      direct_sources.uniq
    end
  end

  protected

  def direct_sources_from_existing_connections
    connections.collect &:direct_source
  end

  def direct_sources_from_reference(reference)
    reference.is_direct_object? ? [reference] # Récupération de la connexion directe
                                : reference.direct_sources # Récursivité sur les références
  end

  def connect_and_sync_direct_sources
    direct_sources.each do |direct_source|
      direct_source.website.connect self, direct_source
      direct_source.sync_with_git
    end
  end
end