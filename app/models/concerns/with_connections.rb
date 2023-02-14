module WithConnections
  extend ActiveSupport::Concern

  included do
    def self.has_connection(kind)
      # TODO
    end
  end

  def connect(dependency)
    return if dependency.in?(university_organizations)
    university_organizations << dependency
  end

  def disconnect(dependency)
    university_organizations.delete dependency
  end
end