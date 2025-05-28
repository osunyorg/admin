module Communication::Website::WithConnectedObjects
  extend ActiveSupport::Concern

  included do
    CONNECTIONS_BLACKLIST = [
      # Les blobs ne sont jamais modifiés, donc on n'a aucun besoin de savoir à quoi ils sont connectés
      'ActiveStorage::Blob'
    ].freeze

    has_many :connections, dependent: :destroy

    after_save :connect_about, if: :saved_change_to_about_id?
  end

  def clean_and_rebuild
    Communication::Website::CleanAndRebuildJob.perform_later(id)
  end

  # Appelé uniquement en asynchrone par Communication::Website::CleanAndRebuildJob
  # (job nocturne une fois par jour + appels forcés depuis la partie Server)
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
    mark_obsolete_git_files
    touch_planned_objects
    get_current_theme_version!
    analyse_repository!
    screenshot!
  end

  def clean
    Communication::Website::CleanJob.perform_later(id)
  end

  def clean_safely
    delete_obsolete_connections_for_self_and_direct_sources
    mark_obsolete_git_files
  end

  # Le site fait le ménage de ses connexions directes uniquement
  def delete_obsolete_connections
    Communication::Website::DeleteObsoleteConnectionsJob.perform_later(id)
  end

  def delete_obsolete_connections_safely
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

  def has_connected_object?(indirect_object)
    connections.for_object(indirect_object).exists?
  end

  def connect(indirect_object, direct_source, direct_source_type: nil)
    # https://developers.osuny.org/docs/admin/sites-web/git/dependencies/iteration-9/
    connect_object(
      indirect_object,
      direct_source,
      direct_source_type: direct_source_type
    ) if should_connect?(indirect_object, direct_source)
    return unless should_connect_recursive_dependencies?(indirect_object)
    indirect_object.recursive_dependencies.each do |dependency|
      connect_object(dependency, direct_source)
    end
  end

  def disconnect(indirect_object, direct_source, direct_source_type: nil)
    direct_source_type ||= direct_source.class.base_class.to_s
    connections.where(university: university,
                      indirect_object: indirect_object,
                      direct_source_id: direct_source.id,
                      direct_source_type: direct_source_type)
                .delete_all
    mark_obsolete_git_files
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

  def connect_about
    self.connect(about, self) if about.present? && about.try(:is_indirect_object?)
    Communication::Website::DeleteObsoleteConnectionsJob.perform_later(id)
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
    indirect_object.is_a?(ActiveRecord::Base) &&
    # On ne connecte pas certains types d'objets, listés dans une black list
    !indirect_object.class.to_s.in?(CONNECTIONS_BLACKLIST)
  end

  def should_connect_recursive_dependencies?(indirect_object)
    # On ne suit pas les objets inexistants
    indirect_object.present? &&
    # On ne suit pas les objets qui n'ont pas de dépendances
    indirect_object.respond_to?(:recursive_dependencies) &&
    # On ne suit pas les objets directs
    !indirect_object.try(:is_direct_object?)
  end

  # Le site fait son ménage de printemps.
  # Méthode appelée par les nettoyages, toujours en arrière plan.
  # Appelé
  # - par un objet avec des connexions lorsqu'il est destroyed (via le clean_websites_if_necessary => CleanJob)
  # - par le website lui-même au changement du about
  def delete_obsolete_connections_for_self_and_direct_sources
    direct_source_ids_per_type_through_connections.each do |direct_source_type, direct_source_ids|
      next if direct_source_type.nil?
      # On récupère une liste d'objets directs d'une même classe
      direct_sources = direct_source_type.safe_constantize.where(id: direct_source_ids)
      # On exécute en synchrone pour chaque objet
      direct_sources.find_each(&:delete_obsolete_connections_safely)
    end
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

  def touch_planned_objects
    events.find_each &:touch
    exhibitions.find_each &:touch
    posts.find_each &:touch
    find_special_page(Communication::Website::Page::CommunicationAgenda)&.touch
  end
end