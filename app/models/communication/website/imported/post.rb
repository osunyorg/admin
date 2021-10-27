# == Schema Information
#
# Table name: communication_website_imported_posts
#
#  id                 :uuid             not null, primary key
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
#  featured_medium_id :uuid
#  post_id            :uuid             not null
#  university_id      :uuid             not null
#  website_id         :uuid             not null
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
#  fk_rails_...  (featured_medium_id => communication_website_imported_media.id)
#  fk_rails_...  (post_id => communication_website_posts.id)
#  fk_rails_...  (university_id => universities.id)
#  fk_rails_...  (website_id => communication_website_imported_websites.id)
#
class Communication::Website::Imported::Post < ApplicationRecord
  include Communication::Website::Imported::WithRichText

  belongs_to :university
  belongs_to :website,
             class_name: 'Communication::Website::Imported::Website'
  belongs_to :post,
             class_name: 'Communication::Website::Post',
             optional: true
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
                                                   website: website.website # Real website, not imported website
      self.post.title = "Untitled" # No title yet
      self.post.save
    else
      # Continue only if there are remote changes
      # Don't touch if there are local changes (post.updated_at > updated_at)
      # Don't touch if there are no remote changes (post.updated_at == updated_at)
      # return unless updated_at > post.updated_at
    end
    puts "Update post #{post.id}"
    sanitized_title = Wordpress.clean_string self.title.to_s
    post.title = sanitized_title unless sanitized_title.blank? # If there is no title, leave it with "Untitled"
    post.slug = slug
    post.description = Wordpress.clean_string excerpt.to_s
    post.text = Wordpress.clean_html content.to_s
    post.created_at = created_at
    post.updated_at = updated_at
    post.published_at = published_at if published_at
    post.published = true
    post.save
    if featured_medium.present?
      unless featured_medium.file.attached?
        featured_medium.load_remote_file!
        featured_medium.save
      end
      post.featured_image.attach(
        io: URI.open(featured_medium.file.blob.url),
        filename: featured_medium.file.blob.filename,
        content_type: featured_medium.file.blob.content_type
      )
    else
      fragment = Nokogiri::HTML.fragment(post.text.to_s)
      image = fragment.css('img').first
      if image.present?
        begin
          url = image.attr('src')
          download_service = DownloadService.download(url)
          post.featured_image.attach(download_service.attachable_data)
          image.remove
          post.update(text: fragment.to_html)
        rescue
        end
      end
    end
    post.update(text: rich_text_with_attachments(post.text.to_s))
  end
end
