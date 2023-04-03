module Communication::Website::WithConnections
  extend ActiveSupport::Concern

  included do
    has_many  :connections
    
    before_save :clean_connections!
  end

  def clean_connections!
    start = Time.now
    connect self
    connections.reload.where('updated_at < ?', start).delete_all
  end

  def connect(object, source)
    connect_object object, source
    return unless object.respond_to?(:recursive_dependencies)
    object.recursive_dependencies.each do |dependency|
      connect_object dependency, source
    end
  end

  def disconnect(object, source)
    connections.where(university: university, object: object, source: source).delete_all
  end

  # TODO factoriser avec les extranets
  def connected_people
    ids = connections.where(object_type: 'University::Person').pluck(:object_id)
    University::Person.where(id: ids)
  end

  def connected_organizations
    ids = connections.where(object_type: 'University::Organization').pluck(:object_id)
    University::Organization.where(id: ids)
  end

  def connection_sources_for(object)
    connections.for_object(object)
               .collect(&:source)
               .uniq
               .compact
  end

  protected

  def connect_object(object, source)
    return unless persisted?
    return if object.nil?
    # On ne connecte pas le site à lui-même
    return if object.is_a?(Communication::Website)
    # puts "connect #{object} (#{object.class})"
    connection = connections.where(university: university, object: object, source: source).first_or_create
    connection.touch if connection.persisted?
  end
end