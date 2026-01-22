module University::Person::WithFacets
  extend ActiveSupport::Concern

  included do
    LIST_OF_FACETS = [
      :administration,
      :teacher,
      :researcher,
      :alumnus,
      :author
    ].freeze

    scope :administration,    -> { where(is_administration: true) }
    scope :authors,           -> { where(is_author: true) }
    scope :teachers,          -> { where(is_teacher: true) }
    scope :researchers,       -> { where(is_researcher: true) }
    scope :alumni,            -> { where(is_alumnus: true) }

    # Filters
    scope :for_facet, -> (facet, language = nil) { where("is_#{facet}": true) }  
  end
end