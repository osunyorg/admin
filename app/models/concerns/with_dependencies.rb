# Les objets ont souvent besoin de WithGit et WithDependencies, mais pas toujours :
# - les blocks ont des dépendances, mais ne sont pas envoyés sur Git en tant qu'objets, ils passent par leur 'about'
# - les menu items passent par le menu
# - les templates et les components de blocks passent par les blocks qui passent par les 'about'
module WithDependencies
  extend ActiveSupport::Concern

  # Cette méthode doit être définie dans chaque objet,
  # et renvoyer un tableau de ses références directes.
  # Jamais de référence indirecte !
  # Elles sont gérées récursivement.
  def dependencies
    []
  end

  # Method is often overriden
  def syncable?
    if respond_to? :published_now?
      published_now?
    elsif respond_to? :published
      published
    else
      true
    end
  end

  def recursive_dependencies(array: [], syncable_only: false)
    # On ne liste pas les objets en cours de suppression
    # return array if respond_to?(:mark_for_destruction?) && mark_for_destruction
    # On renvoie l'array tel quel, non modifié, si on demande les contenus syncable_only et que le contenu ne l'est pas
    return array unless dependency_should_be_synced?(self, syncable_only)
    dependencies.each do |dependency|
      # Si l'objet ne doit pas être ajouté on n'ajoute pas non plus ses dépendances récursives
      # C'est le fait de couper ici qui évite la boucle infinie
      next unless dependency_should_be_added?(array, dependency, syncable_only)
      array << dependency
      next unless dependency.respond_to?(:recursive_dependencies)
      array = dependency.recursive_dependencies(array: array, syncable_only: syncable_only)
    end
    array.compact
  end

  def recursive_dependencies_unsyncable
    @recursive_dependencies_unsyncable ||= recursive_dependencies - recursive_dependencies(syncable_only: true)
  end

  protected
  
  def dependency_should_be_added?(array, dependency, syncable_only)
    # Si l'objet est déjà là, on ne doit pas l'ajouter
    # Si l'objet n'est pas syncable, on ne doit pas l'ajouter non plus
    !dependency.in?(array) && dependency_should_be_synced?(dependency, syncable_only)
  end
  
  def dependency_should_be_synced?(dependency, syncable_only)
    # Si on n'est pas en syncable only on liste tout, sinon, il faut analyser
    !syncable_only || (dependency.respond_to?(:syncable?) && dependency.syncable?)
  end

end