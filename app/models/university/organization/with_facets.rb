module University::Organization::WithFacets
  extend ActiveSupport::Concern

  included do
    LIST_OF_FACETS = [
      :location,
      :school,
      :laboratory
    ].freeze

    scope :locations,    -> { where(is_location: true) }
    scope :schools,      -> { where(is_school: true) }
    scope :laboratories, -> { where(is_laboratory: true) }
    scope :for_facet, -> (facet, language = nil) { where("is_#{facet}": true) }  
  end

  def facets
    LIST_OF_FACETS.reject do |facet|
      !public_send("is_#{facet}")
    end
  end

  def location_facets
    @location_facets ||= University::Organization::Localization::Location.where(id: localization_ids)
  end

  def school_facets
    @school_facets ||= University::Organization::Localization::School.where(id: localization_ids)
  end

  def laboratory_facets
    @laboratory_facets ||= University::Organization::Localization::Laboratory.where(id: localization_ids)
  end
end