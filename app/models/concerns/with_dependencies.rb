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
    array
  end

  protected

  def add_dependency_to_array(array = [], dependency, recursive: false)
    return if dependency.in?(array)
    array << dependency
    return unless recursive
    return unless dependency.respond_to?(:dependencies)
    array = array | dependency.dependencies(array)
    array
  end
end