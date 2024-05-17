module Communication::Website::WithConnectedObjects
  extend ActiveSupport::Concern

  included do
    has_many :connections

    after_save :connect_about, if: :saved_change_to_about_id?
  end

  def clean_and_rebuild
    return unless git_repository.valid?
    # On force le déverrouillage pour faire un nettoyage
    unlock_for_background_jobs!
    lock_for_background_jobs!
    begin
      clean_and_rebuild_safely
    ensure
      unlock_for_background_jobs!
    end
  end
  handle_asynchronously :clean_and_rebuild, queue: :cleanup

  # Le site fait le ménage de ses connexions directes uniquement
  def delete_obsolete_connections
    Communication::Website::Connection.delete_useless_connections(
      # On ne liste pas toutes les connexions du website, 
      # mais juste les connexions pour lesquelles le site est la source.
      connections.where(direct_source: self), 
      # On prend l'about et ses dépendances récursives.
      # On ne prend pas toutes les dépendances parce qu'on s'intéresse 
      # uniquement à la connexion via about.
      about_dependencies
    )
  end

  # Le site fait son ménage de printemps
  # Appelé
  # - par un objet avec des connexions lorsqu'il est destroyed
  # - par le website lui-même au changement du about
  def delete_obsolete_connections_for_self_and_direct_sources
    direct_source_ids_per_type_through_connections.each do |direct_source_type, direct_source_ids|
      # On récupère une liste d'objets directs d'une même classe
      direct_sources = direct_source_type.safe_constantize.where(id: direct_source_ids)
      # On exécute en synchrone pour chaque objet
      direct_sources.find_each(&:delete_obsolete_connections)
    end
  end

  def has_connected_object?(indirect_object)
    connections.for_object(indirect_object).exists?
  end

  def connect(indirect_object, direct_source, direct_source_type: nil)
    connect_object indirect_object, direct_source, direct_source_type: direct_source_type
    return unless indirect_object.respond_to?(:recursive_dependencies)
    indirect_object.recursive_dependencies.each do |dependency|
      connect_object dependency, direct_source
    end
  end

  def connect_and_sync(indirect_object, direct_source, direct_source_type: nil)
    connect(indirect_object, direct_source, direct_source_type: direct_source_type)
    direct_source.sync_with_git
  end

  def disconnect(indirect_object, direct_source, direct_source_type: nil)
    direct_source_type ||= direct_source.class.base_class.to_s
    connections.where(university: university,
                      indirect_object: indirect_object,
                      direct_source_id: direct_source.id,
                      direct_source_type: direct_source_type)
                .delete_all
  end

  def disconnect_and_sync(indirect_object, direct_source, direct_source_type: nil)
    disconnect(indirect_object, direct_source, direct_source_type: direct_source_type)
    direct_source.sync_with_git
    destroy_obsolete_git_files
  end

  # TODO factoriser avec les extranets
  def connected_people
    ids = connections.where(indirect_object_type: 'University::Person').pluck(:indirect_object_id)
    University::Person.where(id: ids)
  end

  def connected_organizations
    ids = connections.where(indirect_object_type: 'University::Organization').pluck(:indirect_object_id)
    University::Organization.where(id: ids)
  end

  def connected_publications
    ids = connections.where(indirect_object_type: 'Research::Publication').pluck(:indirect_object_id)
    Research::Publication.where(id: ids)
  end

  # ensure the object "website" respond to both is_direct_object? and is_indirect_object? as website doesn't include neither as_direct_object nor as_indirect_object
  def is_direct_object?
    true
  end

  def is_indirect_object?
    false
  end

  protected

  def direct_objects_association_names
    [
      :pages,
      :posts,
      :post_categories,
      :events,
      :agenda_categories,
      :projects,
      :portfolio_categories,
      :menus
    ]
  end

  def clean_and_rebuild_safely
    direct_objects_association_names.each do |association_name|
      # We use find_each to avoid loading all the objects in memory
      public_send(association_name).find_each(&:connect_dependencies)
    end
    connect(about, self) if about.present?
    delete_obsolete_connections_for_self_and_direct_sources
    # In the same job
    create_missing_special_pages
    initialize_menus
    sync_with_git_safely
    destroy_obsolete_git_files_safely
    get_current_theme_version!
    screenshot!
  end

  def connect_about
    self.connect(about, self) if about.present? && about.try(:is_indirect_object?)
    delay(queue: :long_cleanup).delete_obsolete_connections
  end

  def about_dependencies
    about.present?  ? [about] + about.recursive_dependencies
                    : []
  end

  def connect_object(indirect_object, direct_source, direct_source_type: nil)
    return unless should_connect?(indirect_object, direct_source)
    # puts "connect #{object} (#{object.class})"
    direct_source_type ||= direct_source.class.base_class.to_s
    connection = connections.where( university: university,
                                    indirect_object: indirect_object,
                                    direct_source_id: direct_source.id,
                                    direct_source_type: direct_source_type)
                            .first_or_create
    connection.touch if connection.persisted?
  end

  def should_connect?(indirect_object, direct_source)
    # Ce cas se produit quand on save un new website et qu'on ne passe pas un validateur
    persisted? &&
    # On ne connecte pas les objets inexistants
    indirect_object.present? &&
    # On ne connecte pas les objets sans source
    direct_source.present? &&
    # On ne connecte pas le site à lui-même
    !indirect_object.is_a?(Communication::Website) &&
    # On ne connecte pas les objets directs (en principe ça n'arrive pas)
    !indirect_object.try(:is_direct_object?) &&
    # On ne connecte pas des objets qui ne sont pas issus de modèles ActiveRecord (comme les composants des blocs)
    indirect_object.is_a?(ActiveRecord::Base)
  end

  # On passe par les connexions pour éviter d'analyser des objets directs qui n'ont pas d'objets indirects du tout
  # Le website lui même est inclus dans le retour (s'il a un about qui déclenche des connexions)
  def direct_source_ids_per_type_through_connections
    # {
    #  'Communication::Website::Post': ['ID1', 'ID2', ...],
    #  'Communication::Website::Page': ['ID1', 'ID2', ...],
    #  'Communication::Website': ['ID1'],
    #  ...
    # }
    connections.group(:direct_source_type)
               .pluck(:direct_source_type, Arel.sql('array_agg(DISTINCT direct_source_id)'))
               .to_h
  end
end