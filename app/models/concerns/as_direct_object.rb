# Ce concern ajoute les éléments nécessaires pour les objets directs :
# - Dépendances (avec et via synchro)
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

    belongs_to :website,
               class_name: 'Communication::Website',
               foreign_key: :communication_website_id

    has_many  :connections,
              as: :direct_source,
              class_name: 'Communication::Website::Connection',
              dependent: :destroy # When the direct object disappears all connections with the object as a source must disappear

    after_save  :connect_dependencies
    after_touch :connect_dependencies
  end

  def is_direct_object?
    true
  end

  def is_indirect_object?
    false
  end

  def connect_dependencies
    dependencies.each do |dependency|
      website.connect(dependency, self)
    end
  end
end