module Communication::Website::WithConnections
  extend ActiveSupport::Concern

  included do
    has_many  :connections
    
    # before_save :clean_connections!
  end

  def clean_connections!
    start = Time.now
    connect self, self
    connections.reload.where('updated_at < ?', start).delete_all
  end

  def connect(indirect_object, direct_source)
    connect_object indirect_object, direct_source
    return unless indirect_object.respond_to?(:recursive_dependencies)
    indirect_object.recursive_dependencies.each do |dependency|
      connect_object dependency, direct_source
    end
  end

  def disconnect(indirect_object, direct_source)
    connections.where(university: university, 
                      indirect_object: indirect_object,
                      direct_source: direct_source)
                .delete_all
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

  def connect_object(indirect_object, direct_source)
    return unless persisted?
    return if indirect_object.nil?
    # On ne connecte pas le site à lui-même
    return if indirect_object.is_a?(Communication::Website)
    # On ne connecte pas les objets directs
    return if indirect_object.respond_to?(:website)
    # puts "connect #{object} (#{object.class})"
    connection = connections.where( university: university, 
                                    indirect_object: indirect_object, 
                                    direct_source: source)
                            .first_or_create
    connection.touch if connection.persisted?
  end
end