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
end