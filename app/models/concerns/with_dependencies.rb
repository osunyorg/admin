module WithDependencies
  extend ActiveSupport::Concern

  # Cette méthode doit être définie dans chaque objet, 
  # et renvoyer un tableau de ses références directes.
  # Jamais de référence indirecte !
  # Elles sont gérées récursivement.
  def direct_dependencies
    []
  end

  def dependencies(array = [])
    direct_dependencies.each do |dependency|
      next if dependency.in?(array)
      array << dependency
      next unless dependency.respond_to?(:dependencies)
      array = array | dependency.dependencies(array)
    end
    array
  end
end