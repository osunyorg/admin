# == Schema Information
#
# Table name: communication_website_imported_pages
#
#  id            :uuid             not null, primary key
#  content       :text
#  path          :text
#  status        :integer          default(0)
#  title         :string
#  url           :text
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  page_id       :uuid             not null
#  university_id :uuid             not null
#  website_id    :uuid             not null
#
# Indexes
#
#  index_communication_website_imported_pages_on_page_id        (page_id)
#  index_communication_website_imported_pages_on_university_id  (university_id)
#  index_communication_website_imported_pages_on_website_id     (website_id)
#
# Foreign Keys
#
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

  before_validation :sync

  default_scope { order(:path) }

  def to_s
    "#{title}"
  end

  protected

  def sync
    if page.nil?
      self.page = Communication::Website::Page.new university: university,
                                                      website: website.website, # Real website, not imported website
                                                      slug: path
      self.page.title = "TMP"
      self.page.save
    end
    # TODO only if not modified since import
    page.title = Wordpress.clean title.to_s
    # TODO add that
    # page.description = description.to_s
    page.text = Wordpress.clean content.to_s
    page.save
  end
end
