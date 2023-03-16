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

  def connect(object)
    connect_object object
    return unless object.respond_to?(:dependencies)
    object.dependencies.each do |dependency|
      connect_object dependency
    end
  end

  def disconnect(object)
    disconnect_object object
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

  protected

  def connect_object(object)
    return if object.nil?
    # On ne connecte pas le site à lui-même
    return if object.is_a?(Communication::Website)
    # puts "connect #{object} (#{object.class})"
    connection = connections.where(university: university, object: object).first_or_create
    connection.touch if connection.persisted?
  end

  def disconnect_object(object)
    connections.where(university: university, object: object).delete_all
  end
end