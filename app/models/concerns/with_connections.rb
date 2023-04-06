# Concern exclusivement utilisé pour les objets indirects
module WithConnections
  extend ActiveSupport::Concern

  included do
    include WithDependencies
    include WithReferences

    has_many :connections, as: :indirect_object, class_name: 'Communication::Website::Connection'
    has_many :websites, through: :connections
    # Ce serait super, mais Rails ne sait pas faire ça avec un objet polymorphe
    # has_many :sources, through: :connections

    after_save :sync_connections
    after_touch :sync_connections
  end

  def for_website?(website)
    website.has_connected_object?(self)
  end

  def direct_sources
    sources = connections.collect &:direct_source
    references.each do |reference|
      reference_is_a_direct_object = reference.respond_to?(:website_id)
      sources += reference_is_a_direct_object ? [reference]
                                              : reference.direct_sources
    end
    sources
  end

  protected

  def sync_connections
    direct_sources.each do |direct_source|
      direct_source.website.connect self, direct_source
      direct_source.save_and_sync
    end
  end
end