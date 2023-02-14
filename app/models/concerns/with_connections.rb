module WithConnections
  extend ActiveSupport::Concern

  included do
    def self.has_connection(klass)
      # university_organizations
      relation = klass.to_s.underscore.gsub('/', '_').pluralize.to_sym
      # University::Organization
      class_name = klass.to_s
      # :communication_website_id
      foreign_key = "#{self.to_s.underscore.gsub('/', '_')}_id".to_sym
      # :university_organization_id
      association_foreign_key = "#{klass.to_s.underscore.gsub('/', '_')}_id".to_sym
      has_and_belongs_to_many relation,
                              class_name: class_name,
                              foreign_key: foreign_key,
                              association_foreign_key: association_foreign_key

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