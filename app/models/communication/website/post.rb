# == Schema Information
#
# Table name: communication_website_posts
#
#  id                       :uuid             not null, primary key
#  featured_image_alt       :string
#  featured_image_credit    :text
#  github_path              :text
#  meta_description         :text
#  pinned                   :boolean          default(FALSE)
#  published                :boolean          default(FALSE)
#  published_at             :datetime
#  slug                     :text
#  summary                  :text
#  text                     :text
#  title                    :string
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  author_id                :uuid             indexed
#  communication_website_id :uuid             not null, indexed
#  language_id              :uuid             not null, indexed
#  original_id              :uuid             indexed
#  university_id            :uuid             not null, indexed
#
# Indexes
#
#  index_communication_website_posts_on_author_id                 (author_id)
#  index_communication_website_posts_on_communication_website_id  (communication_website_id)
#  index_communication_website_posts_on_language_id               (language_id)
#  index_communication_website_posts_on_original_id               (original_id)
#  index_communication_website_posts_on_university_id             (university_id)
#
# Foreign Keys
#
#  fk_rails_1e0d058a25  (university_id => universities.id)
#  fk_rails_bbbef3b1e9  (original_id => communication_website_posts.id)
#  fk_rails_d1c1a10946  (communication_website_id => communication_websites.id)
#  fk_rails_e0eec447b0  (author_id => university_people.id)
#
class Communication::Website::Post < ApplicationRecord
  include Sanitizable
  include WithAccessibility
  include WithBlobs
  include WithBlocks
  include WithDuplication
  include WithFeaturedImage
  include WithGit
  include WithMenuItemTarget
  include WithPermalink
  include WithSlug # We override slug_unavailable? method
  include WithTranslations
  include WithUniversity

  has_summernote :text # TODO: Remove text attribute

  has_one :imported_post,
          class_name: 'Communication::Website::Imported::Post',
          dependent: :destroy
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

  before_validation :set_published_at
  after_save_commit :update_authors_statuses!, if: :saved_change_to_author_id?

  scope :published, -> {
    where("
      communication_website_posts.published = true AND
      DATE(communication_website_posts.published_at) <= now()
    ")
  }
  scope :published_in_the_future, -> {
    where("
      communication_website_posts.published = true AND
      DATE(communication_website_posts.published_at) > now()
    ")
  }
  scope :ordered, -> { order(pinned: :desc, published_at: :desc, created_at: :desc) }
  scope :recent, -> { order(published_at: :desc).limit(5) }
  scope :for_author, -> (author_id) { where(author_id: author_id) }
  scope :for_category, -> (category_id) { joins(:categories).where(communication_website_categories: { id: category_id }).distinct }
  scope :for_pinned, -> (pinned) { where(pinned: pinned == 'true') }
  scope :for_search_term, -> (term) {
    where("
      unaccent(communication_website_posts.meta_description) ILIKE unaccent(:term) OR
      unaccent(communication_website_posts.summary) ILIKE unaccent(:term) OR
      unaccent(communication_website_posts.text) ILIKE unaccent(:term) OR
      unaccent(communication_website_posts.title) ILIKE unaccent(:term)
    ", term: "%#{sanitize_sql_like(term)}%")
  }

  def published?
    published && published_at && published_at.to_date <= Date.today
  end

  # Is it used?
  def path
    # used in menu_item#static_target
    "/#{published_at.strftime "%Y/%m/%d"}/#{slug}"
  end

  def git_path(website)
    "#{git_path_content_prefix(website)}posts/#{static_path}.html" if website.id == communication_website_id && published && published_at
  end

  def static_path
    "#{published_at.year}/#{published_at.strftime "%Y-%m-%d"}-#{slug}"
  end

  def template_static
    "admin/communication/websites/posts/static"
  end

  def git_dependencies(website)
    dependencies = [self] + website.menus
    dependencies += categories
    dependencies += active_storage_blobs
    dependencies += git_block_dependencies
    dependencies += university.communication_blocks.where(template_kind: :posts).includes(:about).map(&:about).uniq
    if author.present?
      dependencies += [author, author.author, translated_author, translated_author.author]
      dependencies += author.active_storage_blobs
      dependencies += translated_author.active_storage_blobs
    end
    dependencies
  end

  def git_destroy_dependencies(website)
    [self] + explicit_active_storage_blobs
  end

  def url
    return unless published
    return if website.url.blank?
    return if website.special_page(Communication::Website::Page::CommunicationPost)&.path.blank?
    return if current_permalink_in_website(website).blank?
    "#{Static.remove_trailing_slash website.url}#{Static.clean_path current_permalink_in_website(website).path}"
  end

  def translated_author
    @translated_author ||= author.find_or_translate!(language)
  end

  def to_s
    "#{title}"
  end

  protected

  def check_accessibility
    accessibility_merge_array blocks
  end

  def slug_unavailable?(slug)
    self.class.unscoped
              .where(communication_website_id: self.communication_website_id, language_id: language_id, slug: slug)
              .where.not(id: self.id)
              .exists?
  end

  def set_published_at
    self.published_at = Time.zone.now if published && published_at.nil?
  end

  def explicit_blob_ids
    super.concat [featured_image&.blob_id]
  end

  def inherited_blob_ids
    [best_featured_image&.blob_id]
  end

  def update_authors_statuses!
    old_author = University::Person.find_by(id: author_id_before_last_save)
    if old_author && old_author.communication_website_posts.none?
      old_author.update_and_sync(is_author: false)
    end
    author.update_and_sync(is_author: true) if author_id
  end

  def translate_additional_data!(translation)
    categories.each do |category|
      translated_category = category.find_or_translate!(translation.language)
      translation.categories << translated_category
    end
    translation.update(author_id: author.find_or_translate!(translation.language).id) if author_id.present?
  end
end
