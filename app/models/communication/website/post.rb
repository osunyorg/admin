# == Schema Information
#
# Table name: communication_website_posts
#
#  id                       :uuid             not null, primary key
#  description              :text
#  github_path              :text
#  old_text                 :text
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
#  fk_rails_...  (author_id => administration_members.id)
#  fk_rails_...  (communication_website_id => communication_websites.id)
#  fk_rails_...  (university_id => universities.id)
#
class Communication::Website::Post < ApplicationRecord
  include Communication::Website::WithMedia
  include WithGithubFiles
  include WithSlug

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
             class_name: 'Administration::Member',
             optional: true
  has_and_belongs_to_many :categories,
                          class_name: 'Communication::Website::Category',
                          join_table: 'communication_website_categories_posts',
                          foreign_key: 'communication_website_post_id',
                          association_foreign_key: 'communication_website_category_id'

  validates :title, presence: true
  validates :slug, uniqueness: { scope: :communication_website_id }

  before_validation :set_published_at, if: :published_changed?

  scope :ordered, -> { order(published_at: :desc, created_at: :desc) }
  scope :recent, -> { order(published_at: :desc).limit(5) }

  def path
    # used in menu_item#jekyll_target
    "/#{website.posts_github_directory}/#{published_at.strftime "%Y/%m/%d"}/#{slug}"
  end

  # Override from WithGithubFiles
  def github_path_generated
    "_posts/#{published_at.year}/#{published_at.strftime "%Y-%m-%d"}-#{slug}.html"
  end

  def to_s
    "#{title}"
  end

  protected

  def slug_unavailable?(slug)
    self.class.unscoped.where(communication_website_id: self.communication_website_id, slug: slug).where.not(id: self.id).exists?
  end

  def set_published_at
    self.published_at = published? ? Time.zone.now : nil
  end
end
