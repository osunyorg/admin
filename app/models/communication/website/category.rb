# == Schema Information
#
# Table name: communication_website_categories
#
#  id                       :uuid             not null, primary key
#  featured_image_alt       :string
#  featured_image_credit    :text
#  github_path              :text
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
#  program_id               :uuid             indexed
#  university_id            :uuid             not null, indexed
#
# Indexes
#
#  idx_communication_website_post_cats_on_communication_website_id  (communication_website_id)
#  index_communication_website_categories_on_language_id            (language_id)
#  index_communication_website_categories_on_original_id            (original_id)
#  index_communication_website_categories_on_parent_id              (parent_id)
#  index_communication_website_categories_on_program_id             (program_id)
#  index_communication_website_categories_on_university_id          (university_id)
#
# Foreign Keys
#
#  fk_rails_3186d8e327  (language_id => languages.id)
#  fk_rails_52bd5968c9  (original_id => communication_website_categories.id)
#  fk_rails_86a9ce3cea  (parent_id => communication_website_categories.id)
#  fk_rails_9d4210dc43  (university_id => universities.id)
#  fk_rails_c7c9f7ddc7  (communication_website_id => communication_websites.id)
#  fk_rails_e58348b119  (program_id => education_programs.id)
#
class Communication::Website::Category < ApplicationRecord
  include Sanitizable
  include WithBlobs
  include WithBlocks
  include WithDependencies
  include WithFeaturedImage
  include WithGit
  include WithMenuItemTarget
  include WithPermalink
  include WithPosition
  include WithSlug # We override slug_unavailable? method
  include WithTranslations
  include WithTree
  include WithUniversity
  include WithWebsites

  has_one                 :imported_category,
                          class_name: 'Communication::Website::Imported::Category',
                          dependent: :destroy
  belongs_to              :university
  belongs_to              :website,
                          foreign_key: :communication_website_id
  belongs_to              :parent,
                          class_name: 'Communication::Website::Category',
                          optional: true
  belongs_to              :program,
                          class_name: 'Education::Program',
                          optional: true
  has_one                 :imported_category,
                          class_name: 'Communication::Website::Imported::Category',
                          dependent: :destroy
  has_many                :children,
                          class_name: 'Communication::Website::Category',
                          foreign_key: :parent_id,
                          dependent: :destroy
  has_and_belongs_to_many :posts,
                          class_name: 'Communication::Website::Post',
                          join_table: 'communication_website_categories_posts',
                          foreign_key: 'communication_website_category_id',
                          association_foreign_key: 'communication_website_post_id'

  validates :name, presence: true

  after_save :update_children_paths, if: :saved_change_to_path?

  def to_s
    "#{name}"
  end

  def git_path(website)
    "#{git_path_content_prefix(website)}categories/#{slug_with_ancestors_slugs}/_index.html"
  end

  def template_static
    "admin/communication/websites/categories/static"
  end

  def direct_dependencies
    active_storage_blobs +
    blocks +
    children +
    posts +
    [parent]
  end

  def git_dependencies(website)
    [self, parent].compact + siblings + descendants + active_storage_blobs + posts + website.menus
  end

  def git_destroy_dependencies(website)
    [self] + descendants + active_storage_blobs
  end

  def update_children_paths
    children.each do |child|
      child.update_column :path, child.generated_path
      child.update_children_paths
    end
  end

  def siblings
    self.class.unscoped.where(parent: parent, university: university, website: website).where.not(id: id)
  end

  def slug_with_ancestors_slugs
    (ancestors.map(&:slug) << slug).join('-')
  end

  def best_featured_image_source(fallback: true)
    return self if featured_image.attached?
    best_source = parent&.best_featured_image_source(fallback: false)
    best_source ||= self if fallback
    best_source
  end

  protected

  def last_ordered_element
    website.categories.where(parent_id: parent_id, language_id: language_id).ordered.last
  end

  def slug_unavailable?(slug)
    self.class.unscoped.where(communication_website_id: self.communication_website_id, language_id: language_id, slug: slug).where.not(id: self.id).exists?
  end

  def explicit_blob_ids
    super.concat [best_featured_image&.blob_id]
  end

  def inherited_blob_ids
    [best_featured_image&.blob_id]
  end
end
