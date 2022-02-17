# == Schema Information
#
# Table name: communication_website_index_pages
#
#  id                       :uuid             not null, primary key
#  breadcrumb_title         :string
#  description              :text
#  featured_image_alt       :string
#  header_text              :string
#  kind                     :integer
#  path                     :string
#  text                     :text
#  title                    :string
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  communication_website_id :uuid             not null, indexed
#  university_id            :uuid             not null, indexed
#
# Indexes
#
#  idx_comm_website_index_page_on_communication_website_id   (communication_website_id)
#  index_communication_website_index_pages_on_university_id  (university_id)
#
# Foreign Keys
#
#  fk_rails_5cd2482227  (communication_website_id => communication_websites.id)
#  fk_rails_7eb45227ae  (university_id => universities.id)
#
class Communication::Website::IndexPage::Home < Communication::Website::IndexPage
  def self.polymorphic_name
    'Communication::Website::IndexPage::Home'
  end

  def git_path(website)
    'content/_index.html'
  end

  def url
    '/'
  end

end
