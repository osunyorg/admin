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
    # connections.where('updated_at < ?', start).destroy_all
  end

  def connect(object, source = nil)
    source = object if source.nil?
    connect_object object, source
    return unless object.respond_to?(:dependencies)
    dependencies = object.dependencies
    dependencies.each do |dependency|
      # Connexion à la source primaire
      connect_object dependency, source
      # Connexion à la dépendance la plus proche
      connect_object dependency, object
    end
  end

  # TODO pas pensé
  def disconnect(object, source = nil)
    source = object if source.nil?
    disconnect_object object, source
    return unless object.respond_to?(:dependencies)
    object.dependencies.each do |dependency|
      disconnect_object dependency, source
    end
  end

  protected

  def connect_object(object, source)
    # puts "connect_object #{object} from #{source}"
    connection = connections.where(university: university, object: object, source: source).first_or_create
    connection.touch if connection.persisted?
  end

  def disconnect_object(object, source)
    connections.where(university: university, object: object, source: source).destroy_all
  end
end