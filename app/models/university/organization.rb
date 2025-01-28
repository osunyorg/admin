# == Schema Information
#
# Table name: university_organizations
#
#  id                   :uuid             not null, primary key
#  active               :boolean          default(TRUE)
#  address              :string
#  city                 :string
#  country              :string
#  email                :string
#  kind                 :integer          default("company")
#  latitude             :float
#  longitude            :float
#  migration_identifier :string
#  nic                  :string
#  phone                :string
#  siren                :string
#  zipcode              :string
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  university_id        :uuid             not null, indexed
#
# Indexes
#
#  index_university_organizations_on_university_id  (university_id)
#
# Foreign Keys
#
#  fk_rails_35fcd198e0  (university_id => universities.id)
#
class University::Organization < ApplicationRecord
  include AsIndirectObject
  include Categorizable
  include Filterable
  include Localizable
  include LocalizableOrderByNameScope
  include Sanitizable
  include Searchable
  include WithCountry
  include WithGeolocation
  include WithKind
  include WithOpenApi
  include WithUniversity

  attr_accessor :created_from_extranet

  has_many :experiences,
           class_name: 'University::Person::Experience',
           dependent: :destroy

  scope :for_search_term, -> (term, language) {
    joins(:localizations)
      .where(university_organization_localizations: { language_id: language.id })
      .where("
        unaccent(university_organizations.address) ILIKE unaccent(:term) OR
        unaccent(university_organizations.city) ILIKE unaccent(:term) OR
        unaccent(university_organizations.country) ILIKE unaccent(:term) OR
        unaccent(university_organization_localizations.meta_description) ILIKE unaccent(:term) OR
        unaccent(university_organizations.email) ILIKE unaccent(:term) OR
        unaccent(university_organization_localizations.long_name) ILIKE unaccent(:term) OR
        unaccent(university_organization_localizations.name) ILIKE unaccent(:term) OR
        unaccent(university_organizations.nic) ILIKE unaccent(:term) OR
        unaccent(university_organizations.phone) ILIKE unaccent(:term) OR
        unaccent(university_organizations.siren) ILIKE unaccent(:term) OR
        unaccent(university_organization_localizations.text) ILIKE unaccent(:term) OR
        unaccent(university_organizations.zipcode) ILIKE unaccent(:term) OR
        unaccent(university_organization_localizations.url) ILIKE unaccent(:term)
      ", term: "%#{sanitize_sql_like(term)}%")
  }
  scope :search_by_siren_or_name, -> (term, language) {
    joins(:localizations)
    .where(university_organization_localizations: { language_id: language.id })
    .where("
      unaccent(university_organizations.siren) ILIKE unaccent(:term) OR
      unaccent(university_organization_localizations.name) ILIKE unaccent(:term)
    ", term: "%#{sanitize_sql_like(term)}%")
  }

  def dependencies
    localizations +
    categories
  end
end
