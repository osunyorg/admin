# == Schema Information
#
# Table name: communication_website_portfolio_categories
#
#  id                       :uuid             not null, primary key
#  featured_image_alt       :text
#  featured_image_credit    :text
#  is_programs_root         :boolean          default(FALSE)
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
#  idx_on_communication_website_id_8f309901d4                     (communication_website_id)
#  idx_on_language_id_6e6ffc92a8                                  (language_id)
#  idx_on_original_id_4cbc9f1290                                  (original_id)
#  idx_on_university_id_a07cc0a296                                (university_id)
#  index_communication_website_portfolio_categories_on_parent_id  (parent_id)
#
# Foreign Keys
#
#  fk_rails_0f0db1988d  (communication_website_id => communication_websites.id)
#  fk_rails_35d652a63c  (parent_id => communication_website_portfolio_categories.id)
#  fk_rails_c82d8a59f0  (language_id => languages.id)
#  fk_rails_d21380c33e  (original_id => communication_website_portfolio_categories.id)
#  fk_rails_eed5f4b819  (university_id => universities.id)
#
class Communication::Website::Portfolio::Category < ApplicationRecord
  include AsDirectObject
  include Contentful
  include Initials
  include Permalinkable
  include Sanitizable
  include Sluggable # We override slug_unavailable? method
  include Translatable
  include Pathable # Included after Sluggable to make sure slug is correct before anything
  include WithBlobs
  include WithFeaturedImage
  include WithMenuItemTarget
  include WithPosition
  include WithTree
  include WithUniversity

  belongs_to              :parent,
                          class_name: 'Communication::Website::Portfolio::Category',
                          optional: true
  belongs_to              :program,
                          class_name: 'Education::Program',
                          optional: true
  has_many                :children,
                          class_name: 'Communication::Website::Portfolio::Category',
                          foreign_key: :parent_id,
                          dependent: :destroy
  has_and_belongs_to_many :projects,
                          class_name: 'Communication::Website::Portfolio::Project',
                          join_table: :communication_website_portfolio_categories_projects,
                          foreign_key: :communication_website_portfolio_category_id,
                          association_foreign_key: :communication_website_portfolio_project_id

  validates :name, presence: true

  def to_s
    "#{name}"
  end

  def git_path(website)
    "#{git_path_content_prefix(website)}projects_categories/#{slug}/_index.html"
  end

  def template_static
    "admin/communication/websites/portfolio/categories/static"
  end

  def dependencies
    active_storage_blobs +
    contents_dependencies +
    [website.config_default_content_security_policy]
  end

  def references
    references = projects + website.menus
    references << parent if parent.present?
    references
  end

  def siblings
    self.class.unscoped.where(parent: parent, university: university, website: website).where.not(id: id)
  end

  # FIXME: Sebou à faire
  def url
    "#"
  end

  protected

  def last_ordered_element
    website.portfolio_categories.where(parent_id: parent_id, language_id: language_id).ordered.last
  end

  def slug_unavailable?(slug)
    self.class.unscoped.where(communication_website_id: self.communication_website_id, language_id: language_id, slug: slug).where.not(id: self.id).exists?
  end
end
