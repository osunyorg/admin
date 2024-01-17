# == Schema Information
#
# Table name: communication_website_agenda_categories
#
#  id                       :uuid             not null, primary key
#  featured_image_alt       :string
#  featured_image_credit    :text
#  meta_description         :text
#  name                     :string
#  path                     :string
#  position                 :integer
#  slug                     :string
#  summary                  :text
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  communication_website_id :uuid             not null, indexed
#  language_id              :uuid             not null, indexed
#  original_id              :uuid             indexed
#  parent_id                :uuid             indexed
#  university_id            :uuid             not null, indexed
#
# Indexes
#
#  idx_communication_website_agenda_cats_on_website_id             (communication_website_id)
#  index_communication_website_agenda_categories_on_language_id    (language_id)
#  index_communication_website_agenda_categories_on_original_id    (original_id)
#  index_communication_website_agenda_categories_on_parent_id      (parent_id)
#  index_communication_website_agenda_categories_on_university_id  (university_id)
#
# Foreign Keys
#
#  fk_rails_1e1b9fbf33  (original_id => communication_website_agenda_categories.id)
#  fk_rails_692dbf7723  (parent_id => communication_website_agenda_categories.id)
#  fk_rails_6cb9a4b8a1  (university_id => universities.id)
#  fk_rails_7b5ad84dda  (communication_website_id => communication_websites.id)
#  fk_rails_b0ddee638d  (language_id => languages.id)
#
class Communication::Website::Agenda::Category < ApplicationRecord
  include AsDirectObject
  include Contentful
  include Sanitizable
  include WithBlobs
  include WithFeaturedImage
  include WithMenuItemTarget
  include WithPermalink
  include WithPosition
  include WithSlug
  include WithTranslations
  include WithUniversity

  belongs_to              :parent,
                          class_name: 'Communication::Website::Agenda::Category',
                          optional: true
  has_and_belongs_to_many :events,
                          class_name: 'Communication::Website::Agenda::Event',
                          join_table: :communication_website_agenda_events_categories,
                          foreign_key: :communication_website_agenda_category_id,
                          association_foreign_key: :communication_website_agenda_event_id

  validates :name, presence: true

  def to_s
    "#{name}"
  end

  def git_path(website)
    "#{git_path_content_prefix(website)}events_categories/#{slug}/_index.html"
  end

  def template_static
    "admin/communication/websites/agenda/categories/static"
  end

  def dependencies
    active_storage_blobs +
    contents_dependencies +
    [website.config_default_content_security_policy]
  end

  def references
    events +
    website.menus
  end

  protected

  def slug_unavailable?(slug)
    self.class.unscoped.where(communication_website_id: self.communication_website_id, language_id: language_id, slug: slug).where.not(id: self.id).exists?
  end

end
