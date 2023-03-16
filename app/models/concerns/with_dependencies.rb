module WithDependencies
  extend ActiveSupport::Concern

  # Cette méthode doit être définie dans chaque objet, 
  # et renvoyer un tableau de ses références directes.
  # Jamais de référence indirecte !
  # Elles sont gérées récursivement.
  def display_dependencies
    []
  end

  def reference_dependencies
    []
  end

  def dependencies(array = [])
    display_dependencies.each do |dependency|
      add_dependency_to_array array, dependency, recursive: true
    end
    reference_dependencies.each do |dependency|
      add_dependency_to_array array, dependency
    end
    array.compact
  end

  protected

  def add_dependency_to_array(array = [], dependency, recursive: false)
    # Pas de boucle infinie !
    return if dependency.in?(array)
    array << dependency
    # On s'arrête là si ce n'est pas récursif
    return unless recursive
    # Si la dépendance n'a pas de dépendances, on s'arrête là de toutes façons
    return unless dependency.respond_to?(:dependencies)
    # On fait l'union des 2 arrays
    array | dependency.dependencies(array)
  end
end