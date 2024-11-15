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
    scope :with_habilitation, -> { where(habilitation: true) }
    scope :for_facet, -> (facet, language = nil) { where("is_#{facet}": true) }  
  end

  def facets
    LIST_OF_FACETS.reject do |facet|
      !public_send("is_#{facet}")
    end
  end

  def administrator_facets
    @administrator_facets ||= University::Person::Localization::Administrator.where(id: localization_ids)
  end

  def author_facets
    @author_facets ||= University::Person::Localization::Author.where(id: localization_ids)
  end

  def researcher_facets
    @researcher_facets ||= University::Person::Localization::Researcher.where(id: localization_ids)
  end

  def teacher_facets
    @teacher_facets ||= University::Person::Localization::Teacher.where(id: localization_ids)
  end
end