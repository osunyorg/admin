# == Schema Information
#
# Table name: communication_website_imported_pages
#
#  id                 :uuid             not null, primary key
#  content            :text
#  data               :jsonb
#  excerpt            :text
#  identifier         :string
#  parent             :string
#  path               :text
#  slug               :text
#  status             :integer          default(0)
#  title              :string
#  url                :text
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  featured_medium_id :uuid
#  page_id            :uuid             not null
#  university_id      :uuid             not null
#  website_id         :uuid             not null
#
# Indexes
#
#  idx_communication_website_imported_pages_on_featured_medium_id  (featured_medium_id)
#  index_communication_website_imported_pages_on_page_id           (page_id)
#  index_communication_website_imported_pages_on_university_id     (university_id)
#  index_communication_website_imported_pages_on_website_id        (website_id)
#
# Foreign Keys
#
#  fk_rails_...  (featured_medium_id => communication_website_imported_media.id)
#  fk_rails_...  (page_id => communication_website_pages.id)
#  fk_rails_...  (university_id => universities.id)
#  fk_rails_...  (website_id => communication_website_imported_websites.id)
#
class Communication::Website::Imported::Page < ApplicationRecord
  belongs_to :university
  belongs_to :website,
             class_name: 'Communication::Website::Imported::Website'
  belongs_to :page,
             class_name: 'Communication::Website::Page',
             optional: true
  belongs_to :featured_medium,
             class_name: 'Communication::Website::Imported::Medium',
             optional: true

  before_validation :sync

  default_scope { order(:path) }

  def data=(value)
    super value
    self.url = value['link']
    self.slug = value['slug']
    self.title = value['title']['rendered']
    self.excerpt = value['excerpt']['rendered']
    self.content = value['content']['rendered']
    self.parent = value['parent']
    self.featured_medium = value['featured_media'] == 0 ? nil : website.media.find_by(identifier: value['featured_media'])
    self.created_at = value['date_gmt']
    self.updated_at = value['modified_gmt']
  end

  def to_s
    "#{title}"
  end

  protected

  def sync
    if page.nil?
      self.page = Communication::Website::Page.new  university: university,
                                                    website: website.website, # Real website, not imported website
                                                    slug: path
      self.page.title = "Untitled"
      self.page.save
    else
      # Continue only if there are remote changes
      # Don't touch if there are local changes (page.updated_at > updated_at)
      # Don't touch if there are no remote changes (page.updated_at == updated_at)
      return unless updated_at > page.updated_at
    end
    puts "Update page #{page.id}"
    page.slug = slug
    page.title = Wordpress.clean title.to_s
    page.description = ActionView::Base.full_sanitizer.sanitize excerpt.to_s
    page.text = Wordpress.clean content.to_s
    page.save
  end
end
