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
#  title                    :string
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  author_id                :uuid
#  communication_website_id :uuid             not null
#  university_id            :uuid             not null
#
# Indexes
#
#  index_communication_website_posts_on_author_id                 (author_id)
#  index_communication_website_posts_on_communication_website_id  (communication_website_id)
#  index_communication_website_posts_on_university_id             (university_id)
#
# Foreign Keys
#
#  fk_rails_...  (author_id => university_people.id)
#  fk_rails_...  (communication_website_id => communication_websites.id)
#  fk_rails_...  (university_id => universities.id)
#
class Communication::Website::Post < ApplicationRecord
  include WithGit
  include WithMedia
  include WithMenuItemTarget
  include WithSlug # We override slug_unavailable? method

  has_rich_text :text
  has_one_attached_deletable :featured_image

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
    "/#{website.posts_github_directory}/#{published_at.strftime "%Y/%m/%d"}/#{slug}/"
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
    self.published_at = published? ? Time.zone.now : nil
  end
end
