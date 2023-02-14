module WithConnections
  extend ActiveSupport::Concern

  included do
    def self.has_connection(klass)
      # university_organizations
      relation = relation_name klass
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

    protected
  
    # University::Organization -> university_organizations
    def self.relation_name(klass)
      klass.to_s.underscore.gsub('/', '_').pluralize.to_sym
    end
  end

  def connect(dependency)
    relation = relation(dependency)
    return if dependency.in?(relation)
    relation << dependency
  end
  
  def disconnect(dependency)
    relation(dependency).delete dependency
  end

  protected
  
  def relation(instance)
    relation_name = self.class.relation_name instance.class
    send relation_name
  end
end