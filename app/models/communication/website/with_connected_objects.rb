module Communication::Website::WithConnectedObjects
  extend ActiveSupport::Concern

  included do
    has_many :connections

    after_save :connect_about, if: :saved_change_to_about_id?
  end

  # Appelé par un objet avec des connexions lorsqu'il est destroyed
  def destroy_obsolete_connections
    # TODO: optimiser
    up_to_date_dependencies = recursive_dependencies
    connections.find_each do |connection|
      connection_obsolete = !connection.indirect_object.in?(up_to_date_dependencies)
      connection.destroy if connection_obsolete
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

  protected

  def connect_about
    self.connect(about, self) if about.present? && about.try(:is_indirect_object?)
    destroy_obsolete_connections
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
    return false unless persisted?
    # On ne connecte pas les objets inexistants
    return false if indirect_object.nil?
    # On ne connecte pas les objets sans source
    return false if direct_source.nil?
    # On ne connecte pas le site à lui-même
    return false if indirect_object.is_a?(Communication::Website)
    # On ne connecte pas les objets directs (en principe ça n'arrive pas)
    return false if indirect_object.try(:is_direct_object?)
    true
  end
end