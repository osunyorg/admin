# Ce concern ajoute les éléments nécessaires pour les objets indirects :
# - connexions
# - dépendances 
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
              # Pas dependent_destroy parce que le processus est plus sophistiqué, et est fait dans la méthode destroy
    has_many  :websites, 
              through: :connections
    # Ce serait super de faire la ligne ci-dessous, mais Rails ne sait pas faire ça avec un objet polymorphe (direct_source)
    # has_many :direct_sources, through: :connections

    after_save  :sync_connections
    after_touch :sync_connections
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

  def destroy
    # On est obligés d'overwrite la méthode destroy pour éviter un problème d'œuf et de poule.
    # On a besoin que les websites puissent recalculer leurs recursive_dependencies
    # et on a besoin que ces recursive_dependencies n'incluent pas l'objet courant, puisqu'il est "en cours de destruction" (ni ses propres recursive_dependencies).
    # Mais si on détruit juste l'objet et qu'on fait un `after_destroy :clean_website_connections` 
    # on ne peut plus accéder aux websites (puisque l'objet est déjà détruit et ses connexions en cascades).
    # Donc : 
    # 1. on stocke les websites 
    # 2. PUIS on détruit les connexions 
    # 3. PUIS on détruit l'objet (la méthode destroy normale)
    # 4. PUIS on demande aux websites stockés de nettoyer leurs connexions
    self.transaction do
      website_ids = websites.pluck(:id)
      connections.destroy_all
      super
      Communication::Website.where(id: website_ids).each do |website|
        website.destroy_obsolete_connections
        website.save_and_sync
      end
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

  def sync_connections
    direct_sources.each do |direct_source|
      direct_source.website.connect self, direct_source
      direct_source.save_and_sync
    end
  end
end