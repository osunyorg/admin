# Ce concern ajoute les éléments nécessaires pour les objets directs :
# - Dépendances
# - Git
# - GitFiles
# - Références
# - Connexions (en tant que source)
module AsDirectObject
  extend ActiveSupport::Concern

  included do
    include WithDependencies
    include WithGit
    include WithGitFiles
    include WithReferences

    has_many  :connections, 
              as: :direct_source,
              class_name: 'Communication::Website::Connection',
              dependent: :destroy # When the direct object disappears all connections with the object as a source must disappear

  end

  def is_direct_object?
    true
  end

  def is_indirect_object?
    false
  end
end