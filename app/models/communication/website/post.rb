# == Schema Information
#
# Table name: communication_website_posts
#
#  id                       :uuid             not null, primary key
#  description              :text
#  featured_image_alt       :string
#  github_path              :text
#  old_text                 :text
#  pinned                   :boolean          default(FALSE)
#  published                :boolean          default(FALSE)
#  published_at             :datetime
#  slug                     :text
#  text_new                 :text
#  title                    :string
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  author_id                :uuid             indexed
#  communication_website_id :uuid             not null, indexed
#  university_id            :uuid             not null, indexed
#
# Indexes
#
#  index_communication_website_posts_on_author_id                 (author_id)
#  index_communication_website_posts_on_communication_website_id  (communication_website_id)
#  index_communication_website_posts_on_university_id             (university_id)
#
# Foreign Keys
#
#  fk_rails_1e0d058a25  (university_id => universities.id)
#  fk_rails_d1c1a10946  (communication_website_id => communication_websites.id)
#  fk_rails_e0eec447b0  (author_id => university_people.id)
#
class Communication::Website::Post < ApplicationRecord
  include WithGit
  include WithFeaturedImage
  include WithBlobs
  include WithMenuItemTarget
  include WithSlug # We override slug_unavailable? method`

  has_rich_text :text
  has_summernote :text_new

  convert_fields_to_summernote :text

  has_one :imported_post,
          class_name: 'Communication::Website::Imported::Post',
          dependent: :destroy
  belongs_to :university
  belongs_to :website,
             class_name: 'Communication::Website',
             foreign_key: :communication_website_id
  belongs_to :author,
             class_name: 'University::Person',
             optional: true
  has_and_belongs_to_many :categories,
                          class_name: 'Communication::Website::Category',
                          join_table: 'communication_website_categories_posts',
                          foreign_key: 'communication_website_post_id',
                          association_foreign_key: 'communication_website_category_id'

  validates :title, presence: true

  before_validation :set_published_at, if: :published_changed?

  scope :published, -> { where(published: true) }
  scope :ordered, -> { order(published_at: :desc, created_at: :desc) }
  scope :recent, -> { order(published_at: :desc).limit(5) }


  def path
    # used in menu_item#static_target
    "/#{published_at.strftime "%Y/%m/%d"}/#{slug}"
  end

  def git_path(website)
    "content/posts/#{published_at.year}/#{published_at.strftime "%Y-%m-%d"}-#{slug}.html" if published_at
  end

  def git_dependencies(website)
    [self] + [author, author&.author] + categories + active_storage_blobs
  end

  def git_destroy_dependencies(website)
    [self] + explicit_active_storage_blobs
  end

  def to_s
    "#{title}"
  end

  protected

  def slug_unavailable?(slug)
    self.class.unscoped
              .where(communication_website_id: self.communication_website_id, slug: slug)
              .where.not(id: self.id)
              .exists?
  end

  def set_published_at
    self.published_at = Time.zone.now if published? && published_at.nil?
  end

  def explicit_blob_ids
    super.concat [featured_image&.blob_id]
  end

  def inherited_blob_ids
    [best_featured_image&.blob_id]
  end
end
