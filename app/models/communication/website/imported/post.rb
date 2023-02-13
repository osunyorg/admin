# == Schema Information
#
# Table name: communication_website_imported_posts
#
#  id                 :uuid             not null, primary key
#  author             :string
#  categories         :jsonb
#  content            :text
#  data               :jsonb
#  excerpt            :text
#  identifier         :string
#  path               :text
#  published_at       :datetime
#  slug               :text
#  status             :integer          default(0)
#  title              :string
#  url                :text
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  featured_medium_id :uuid             indexed
#  post_id            :uuid             indexed
#  university_id      :uuid             not null, indexed
#  website_id         :uuid             not null, indexed
#
# Indexes
#
#  idx_communication_website_imported_posts_on_featured_medium_id  (featured_medium_id)
#  index_communication_website_imported_posts_on_post_id           (post_id)
#  index_communication_website_imported_posts_on_university_id     (university_id)
#  index_communication_website_imported_posts_on_website_id        (website_id)
#
# Foreign Keys
#
#  fk_rails_78380969b3  (featured_medium_id => communication_website_imported_media.id)
#  fk_rails_a5bc137386  (university_id => universities.id)
#  fk_rails_de8b4a9cfe  (website_id => communication_website_imported_websites.id)
#  fk_rails_f9a08c7c77  (post_id => communication_website_posts.id)
#
class Communication::Website::Imported::Post < ApplicationRecord
  include WithUniversity
  include Communication::Website::Imported::WithFeaturedImage

  belongs_to :website,
             class_name: 'Communication::Website::Imported::Website'
  belongs_to :post,
             class_name: 'Communication::Website::Post',
             optional: true
  alias_attribute :generated_object, :post
  belongs_to :featured_medium,
             class_name: 'Communication::Website::Imported::Medium',
             optional: true

  before_validation :sync

  default_scope { order(path: :desc) }

  def data=(value)
    super value
    self.url = value['link']
    self.slug = value['slug']
    self.path = URI(self.url).path
    self.title = value['title']['rendered']
    self.excerpt = value['excerpt']['rendered']
    self.content = value['content']['rendered']
    self.author = value['author']
    self.categories = value['categories']
    self.created_at = value['date_gmt']
    self.updated_at = value['modified_gmt']
    self.published_at = value['date_gmt']
    self.featured_medium = website.media.find_by(identifier: value['featured_media']) unless value['featured_media'] == 0
  end

  def to_s
    "#{title}"
  end

  protected

  def sync
    if post.nil?
      self.post = Communication::Website::Post.new university: university,
                                                   website: website.website, # Real website, not imported website
                                                   language: website.website.default_language
      self.post.title = "Untitled" # No title yet
      self.post.save
    else
      # Continue only if there are remote changes, and no recent local changes
      # updated_at reflects last update on wordpress, based on the last import
      # Don't touch if there are local changes (post.updated_at > updated_at)
      # Don't touch if there are no remote changes (post.updated_at == updated_at)
      return unless ENV['APPLICATION_ENV'] == 'development' || updated_at > post.updated_at
    end
    puts "Update post #{post.id}"
    sanitized_title = Wordpress.clean_string self.title.to_s
    post.title = sanitized_title unless sanitized_title.blank? # If there is no title, leave it with "Untitled"
    post.slug = slug
    post.meta_description = Wordpress.clean_string excerpt.to_s
    post.created_at = created_at
    post.updated_at = updated_at
    post.published_at = published_at if published_at
    post.published = true

    imported_author = website.authors.where(identifier: author).first
    post.author = imported_author.author if imported_author&.author.present?
    imported_categories = website.categories.where(identifier: categories)
    imported_categories.each do |imported_category|
      post.categories << imported_category.category unless post.categories.pluck(:id).include?(imported_category.category_id)
    end
    post.save

    chapter = post.blocks.where(university: website.university, template_kind: :chapter).first_or_create
    chapter_data = chapter.data.deep_dup
    chapter_data['text'] = Wordpress.clean_html(content.to_s)
    chapter.data = chapter_data
    chapter.save
  end

end
