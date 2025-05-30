# Ce concern ajoute les éléments nécessaires pour les objets directs :
# - Dépendances et références (avec et via synchro)
# - Connexions (en tant que source)
module AsDirectObject
  extend ActiveSupport::Concern

  include WithDependencies

  included do
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
  def delete_obsolete_connections
    Communication::Website::DirectObject::DeleteObsoleteConnectionsJob.perform_later(website.id, direct_object: self)
  end

  def delete_obsolete_connections_safely
    Communication::Website::Connection.delete_useless_connections(
      connections,
      recursive_dependencies
    )
  end

end
