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
    # Filters
    scope :for_facet, -> (facet, language = nil) { where("is_#{facet}": true) }  
  end
end