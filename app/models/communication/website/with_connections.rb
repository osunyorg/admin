module Communication::Website::WithConnections
  extend ActiveSupport::Concern

  included do
    has_many  :connections
    has_many  :connected_organizations,
              -> { distinct },
              through: :connections,
              source: :object,
              source_type: 'University::Organization'
    
    after_save :clean_connections!
  end

  def clean_connections!
    start = Time.now
    connect self
    connections.where('updated_at < ?', start).destroy_all
  end

  def connect(object, source = nil)
    connect_object object, source
    return unless object.respond_to?(:dependencies)
    dependencies = object.dependencies
    puts "#{dependencies.count} dependencies to connect"
    dependencies.each do |dependency|
      connect_object dependency, source
      connect_object dependency, object
    end
  end

  # TODO pas pensé
  def disconnect(object, source = nil)
    disconnect_object object, source
    return unless object.respond_to?(:dependencies)
    object.dependencies.each do |dependency|
      disconnect_object dependency, source
      disconnect_object dependency, object # Faut-il la double connexion ?
    end
  end

  protected

  def connect_object(object, source)
    puts "connect_object #{object} from #{source}"
    connection = connections.where(university: university, object: object, source: source).first_or_create
    connection.touch if connection.persisted?
  end

  def disconnect_object(object, source)
    connections.where(university: university, object: object, source: source).destroy_all
  end
end