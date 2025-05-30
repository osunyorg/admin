# == Schema Information
#
# Table name: research_laboratories
#
#  id            :uuid             not null, primary key
#  address       :string
#  city          :string
#  country       :string
#  zipcode       :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  university_id :uuid             not null, indexed
#
# Indexes
#
#  index_research_laboratories_on_university_id  (university_id)
#
# Foreign Keys
#
#  fk_rails_f61d27545f  (university_id => universities.id)
#
class Research::Laboratory < ApplicationRecord
  include AsIndirectObject
  include Filterable
  include GeneratesGitFiles
  include Localizable
  include LocalizableOrderByNameScope
  include Sanitizable
  include Searchable
  include WebsitesLinkable
  include WithCountry

  belongs_to  :university
  has_many    :communication_websites,
              class_name: 'Communication::Website',
              as: :about,
              dependent: :nullify
  has_many    :axes,
              class_name: 'Research::Laboratory::Axis',
              foreign_key: :research_laboratory_id,
              dependent: :destroy

  has_and_belongs_to_many :researchers,
                          class_name: 'University::Person',
                          foreign_key: :research_laboratory_id,
                          association_foreign_key: :university_person_id

  validates :address, :city, :zipcode, :country, presence: true

  scope :for_search_term, -> (term, language = nil) {
    joins(:localizations)
      .where(research_laboratory_localizations: { language_id: language.id })
      .where("
        unaccent(research_laboratories.address) ILIKE unaccent(:term) OR
        unaccent(research_laboratories.city) ILIKE unaccent(:term) OR
        unaccent(research_laboratories.country) ILIKE unaccent(:term) OR
        unaccent(research_laboratory_localizations.name) ILIKE unaccent(:term) OR
        unaccent(research_laboratories.zipcode) ILIKE unaccent(:term)
      ", term: "%#{sanitize_sql_like(term)}%")
  }

  def full_address
    [address, zipcode, city].compact.join ' '
  end

  def dependencies
    localizations +
    axes +
    researchers.map(&:researcher_facets)
  end

  def has_administrators?
    false
  end

  def has_researchers?
    researchers.any?
  end

  def has_teachers?
    false
  end

  def has_education_programs?
    false
  end

  def has_education_diplomas?
    false
  end

  # TODO en fait un laboratoire peut avoir des locations mais il faut le coder
  def has_administration_locations?
    false
  end

  def has_research_papers?
    false
  end

  def has_research_volumes?
    false
  end
end
