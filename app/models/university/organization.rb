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
  include Backlinkable
  include Contentful # TODO: remove afterwards
  # include Initials
  include Permalinkable # TODO: remove afterwards
  include Sanitizable
  # include Shareable
  # include Sluggable
  include Localizable # TODO: à adapter
  include WithBlobs
  include WithCountry
  include WithGeolocation
  # include WithGitFiles
  include WithUniversity

  attr_accessor :created_from_extranet

  # has_summernote :text

  has_and_belongs_to_many :categories,
                          class_name: 'University::Organization::Category',
                          join_table: :university_organizations_categories
  has_many :experiences,
           class_name: 'University::Person::Experience',
           dependent: :destroy

  has_one_attached_deletable :logo # TODO: remove afterwards
  has_one_attached_deletable :logo_on_dark_background # TODO: remove afterwards

  alias :featured_image :logo # TODO: remove afterwards

  # validates_presence_of :name # TODO: remove afterwards
  # validates_uniqueness_of :name, scope: [:university_id, :language_id] # TODO: remove afterwards
  # validates :logo, size: { less_than: 1.megabytes } # TODO: remove afterwards
  # validates :logo_on_dark_background, size: { less_than: 1.megabytes } # TODO: remove afterwards
  # Organization can be created from extranet with only their name. Be careful for future validators. # TODO: remove afterwards
  # There is an attribute accessor above : `created_from_extranet` # TODO: remove afterwards

  # TODO: à ré-écrire
  scope :ordered, -> { order(:name) }
  scope :for_kind, -> (kind) { where(kind: kind) }
  scope :for_category, -> (category_id) { includes(:categories).where(categories: { id: category_id })}
  # TODO: à ré-écrire
  scope :for_search_term, -> (term) {
    where("
      unaccent(university_organizations.address) ILIKE unaccent(:term) OR
      unaccent(university_organizations.city) ILIKE unaccent(:term) OR
      unaccent(university_organizations.country) ILIKE unaccent(:term) OR
      unaccent(university_organizations.meta_description) ILIKE unaccent(:term) OR
      unaccent(university_organizations.email) ILIKE unaccent(:term) OR
      unaccent(university_organizations.long_name) ILIKE unaccent(:term) OR
      unaccent(university_organizations.name) ILIKE unaccent(:term) OR
      unaccent(university_organizations.nic) ILIKE unaccent(:term) OR
      unaccent(university_organizations.phone) ILIKE unaccent(:term) OR
      unaccent(university_organizations.siren) ILIKE unaccent(:term) OR
      unaccent(university_organizations.text) ILIKE unaccent(:term) OR
      unaccent(university_organizations.zipcode) ILIKE unaccent(:term) OR
      unaccent(university_organizations.url) ILIKE unaccent(:term)
    ", term: "%#{sanitize_sql_like(term)}%")
  }
  # TODO: à ré-écrire
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
    # + localizations ?
    active_storage_blobs +
    categories +
    blocks
  end

  # def translatable_relations
  #   [
  #     { relation: :categories, list: categories }
  #   ]
  # end

  # def git_path(website)
  #   "#{git_path_content_prefix(website)}organizations/#{slug}.html" if for_website?(website)
  # end

  # def to_s
  #   "#{name}"
  # end

  
  def translate_other_attachments(translation)
    translate_attachment(translation, :logo) if logo.attached?
    translate_attachment(translation, :logo_on_dark_background) if logo_on_dark_background.attached?
  end
  
  protected

  def backlinks_blocks(website)
    website.blocks.organizations
  end

  # def explicit_blob_ids
  #   [
  #     logo&.blob_id,
  #     logo_on_dark_background&.blob_id,
  #     shared_image&.blob_id
  #   ]
  # end
end
