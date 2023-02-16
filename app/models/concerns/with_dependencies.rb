module WithDependencies
  extend ActiveSupport::Concern

  # Cette méthode doit être définie dans chaque objet, 
  # et renvoyer un tableau de ses références directes.
  # Jamais de référence indirecte !
  # Elles sont gérées récursivement
  def direct_dependencies
    []
  end

  def dependencies(list = [])
    direct_dependencies.each do |dependency|
      next if dependency.in?(list)
      list << dependency
      next unless dependency.respond_to?(:dependencies)
      list += dependency.dependencies(list)
    end
    list
  end
end