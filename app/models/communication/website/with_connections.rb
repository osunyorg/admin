module Communication::Website::WithConnections
  extend ActiveSupport::Concern

  included do
    has_many  :connections
    
    before_save :clean_connections!
  end

  def clean_connections!
    start = Time.now
    connect self
    connections.where('updated_at < ?', start).destroy_all
  end

  def connect(object)
    # On ne connecte pas le site à lui-même, ni un objet à lui-même    
    connect_object object unless object.is_a?(Communication::Website)
    return unless object.respond_to?(:dependencies)
    dependencies = object.dependencies
    dependencies.each do |dependency|
      connect_object dependency
    end
  end

  # TODO pas pensé
  def disconnect(object)
    disconnect_object object
    return unless object.respond_to?(:dependencies)
    object.dependencies.each do |dependency|
      disconnect_object dependency
    end
  end

  protected

  def connect_object(object)
    # puts "connect_object #{object} from #{source}"
    connection = connections.where(university: university, object: object).first_or_create
    connection.touch if connection.persisted?
  end

  def disconnect_object(object)
    connections.where(university: university, object: object).destroy_all
  end
end