# == Schema Information
#
# Table name: university_organizations
#
#  id                 :uuid             not null, primary key
#  active             :boolean          default(TRUE)
#  address            :string
#  address_additional :string
#  address_name       :string
#  city               :string
#  country            :string
#  email              :string
#  kind               :integer          default("company")
#  latitude           :float
#  linkedin           :string
#  long_name          :string
#  longitude          :float
#  mastodon           :string
#  meta_description   :text
#  name               :string
#  nic                :string
#  phone              :string
#  siren              :string
#  slug               :string           indexed
#  summary            :text
#  text               :text
#  twitter            :string
#  url                :string
#  zipcode            :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  language_id        :uuid             indexed
#  original_id        :uuid             indexed
#  university_id      :uuid             not null, indexed
#
# Indexes
#
#  index_university_organizations_on_language_id    (language_id)
#  index_university_organizations_on_original_id    (original_id)
#  index_university_organizations_on_slug           (slug)
#  index_university_organizations_on_university_id  (university_id)
#
# Foreign Keys
#
#  fk_rails_35fcd198e0  (university_id => universities.id)
#  fk_rails_3a9208fa29  (language_id => languages.id)
#  fk_rails_5af11ea0cc  (original_id => university_organizations.id)
#
class University::Organization < ApplicationRecord
  include AsIndirectObject
  include Contentful # TODO L10N : To remove
  # include Initials
  include Permalinkable # TODO L10N : To remove
  include Sanitizable
  include Shareable # TODO L10N : To remove
  include Localizable
  include WithBlobs # TODO L10N : To remove
  include WithCountry
  include WithGeolocation
  # include WithGitFiles # TODO L10N : To remove
  include WithUniversity

  attr_accessor :created_from_extranet

  has_and_belongs_to_many :categories,
                          class_name: 'University::Organization::Category',
                          join_table: :university_organizations_categories
  has_many :experiences,
           class_name: 'University::Person::Experience',
           dependent: :destroy

  has_one_attached_deletable :logo # TODO L10N : To remove
  has_one_attached_deletable :logo_on_dark_background # TODO L10N : To remove

  alias :featured_image :logo # TODO L10N : To remove

  # TODO L10N : To understand
  scope :ordered, -> (language) {
    # Define a raw SQL snippet for the conditional aggregation
    # This selects the name of the localization in the specified language,
    # or falls back to the first localization name if the specified language is not present.
    localization_name_select = <<-SQL
      COALESCE(
        MAX(CASE WHEN localizations.language_id = '#{language.id}' THEN localizations.name END),
        MAX(localizations.name) FILTER (WHERE localizations.rank = 1)
      ) AS localization_name
    SQL

    # Join the organizations table with a subquery that ranks localizations
    # The subquery assigns a rank to each localization, with 1 being the first localization for each organization
    joins(sanitize_sql_array([<<-SQL
      LEFT JOIN (
        SELECT
          localizations.*,
          ROW_NUMBER() OVER(PARTITION BY localizations.about_id ORDER BY localizations.created_at ASC) as rank
        FROM
          university_organization_localizations as localizations
      ) localizations ON university_organizations.id = localizations.about_id
    SQL
    ]))
    .select("university_organizations.*", localization_name_select)
    .group("university_organizations.id")
    .order("localization_name ASC")
  }

  scope :for_kind, -> (kind) { where(kind: kind) }
  scope :for_category, -> (category_id) { includes(:categories).where(categories: { id: category_id })}
  # TODO L10N : To rewrite (should add a parameter language and filter to localizations only for this language)
  scope :for_search_term, -> (term) {
    joins(:localizations)
      # TODO L10N : To add after filters rework @pabois
      .where("
        unaccent(university_organizations.address) ILIKE unaccent(:term) OR
        unaccent(university_organizations.city) ILIKE unaccent(:term) OR
        unaccent(university_organizations.country) ILIKE unaccent(:term) OR
        unaccent(university_organizations.meta_description) ILIKE unaccent(:term) OR
        unaccent(university_organizations.email) ILIKE unaccent(:term) OR
        unaccent(university_organization_localizations.long_name) ILIKE unaccent(:term) OR
        unaccent(university_organization_localizations.name) ILIKE unaccent(:term) OR
        unaccent(university_organizations.nic) ILIKE unaccent(:term) OR
        unaccent(university_organizations.phone) ILIKE unaccent(:term) OR
        unaccent(university_organizations.siren) ILIKE unaccent(:term) OR
        unaccent(university_organization_localizations.text) ILIKE unaccent(:term) OR
        unaccent(university_organizations.zipcode) ILIKE unaccent(:term) OR
        unaccent(university_organizations.url) ILIKE unaccent(:term)
      ", term: "%#{sanitize_sql_like(term)}%")
  }
  # TODO L10N : To rewrite
  scope :search_by_siren_or_name, -> (term) {
    where("
      unaccent(university_organizations.siren) ILIKE unaccent(:term) OR
      unaccent(university_organizations.name) ILIKE unaccent(:term)
    ", term: "%#{sanitize_sql_like(term)}%")
  }

  enum kind: {
    company: 10,
    non_profit: 20,
    government: 30
  }

  def dependencies
    localizations +
    categories
  end

  # TODO L10N : to remove
  def translate_other_attachments(translation)
    translate_attachment(translation, :logo) if logo.attached?
    translate_attachment(translation, :logo_on_dark_background) if logo_on_dark_background.attached?
    translate_attachment(translation, :shared_image) if shared_image.attached?
  end

end
