module WithSimpleDependencies
  extend ActiveSupport::Concern

  # Cette méthode doit être définie dans chaque objet, 
  # et renvoyer un tableau de ses références directes.
  # Jamais de référence indirecte !
  # Elles sont gérées récursivement
  def direct_dependencies
    []
  end

  def simple_dependencies(list = [])
    direct_dependencies.each do |dependency|
      next if dependency.in?(list)
      list << dependency
      next unless dependency.respond_to?(:simple_dependencies)
      list += dependency.simple_dependencies(list)
    end
    list
  end
end