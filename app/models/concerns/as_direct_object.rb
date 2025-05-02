# Ce concern ajoute les éléments nécessaires pour les objets directs :
# - Dépendances (avec et via synchro)
# - Git
# - GitFiles
# - Références
# - Connexions (en tant que source)
module AsDirectObject
  extend ActiveSupport::Concern

  include WithDependencies
  include WithGit
  include WithReferences

  included do
    belongs_to :website,
               class_name: 'Communication::Website',
               foreign_key: :communication_website_id

    has_many  :connections,
              as: :direct_source,
              class_name: 'Communication::Website::Connection',
              dependent: :destroy # When the direct object disappears all connections with the object as a source must disappear

    after_save  :connect_dependencies, :generate_git_file
    after_touch :connect_dependencies, :generate_git_file
  end

  def websites
    [website]
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

  # L'objet fait son ménage
  # TODO Cette méthode devrait être appelée dès qu'on enregistre un objet indirect,
  # sur chaque `direct_source` connectée (via les connexions).
  def delete_obsolete_connections
    Communication::Website::Connection.delete_useless_connections(
      connections,
      recursive_dependencies
    )
  end

  protected

  def generate_git_file
    return unless respond_to?(:git_files)
    Communication::Website::GitFile.generate website, self
  end
end
