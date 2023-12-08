module Communication::Extranet::WithConnectedObjects
  extend ActiveSupport::Concern

  included do
    has_many :connections, dependent: :destroy
  end

  def connected?(object)
    connections.where(university: university, about: object).any?
  end

  def connect(object)
    connections.where(university: university, about: object).first_or_create
  end

  def disconnect(object)
    connections.where(university: university, about: object).destroy_all
  end

  def connected_organizations
    ids = connections.where(about_type: 'University::Organization').pluck(:about_id)
    university.organizations.where(id: ids)
  end

  def connected_people
    ids = connections.where(about_type: 'University::Person').pluck(:about_id)
    university.people.where(id: ids)
  end

  def experiences_through_connections
    university.person_experiences.where(person_id: connected_people, organization_id: connected_organizations)
  end

end
