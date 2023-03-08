module Communication::Extranet::WithConnections
  extend ActiveSupport::Concern

  included do
    has_many :connections
  end

  def connected?(object)
    connections.where(university: university, object: object).any?
  end

  def connect(object)
    connections.where(university: university, object: object).first_or_create
  end

  def disconnect(object)
    connections.where(university: university, object: object).destroy_all
  end

  def connected_organizations
    ids = connections.where(object_type: 'University::Organization').pluck(:object_id)
    University::Organization.where(id: ids)
  end

  def connected_persons
    ids = connections.where(object_type: 'University::Person').pluck(:object_id)
    University::Person.where(id: ids)
  end

end