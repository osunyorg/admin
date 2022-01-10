# == Schema Information
#
# Table name: communication_website_homes
#
#  id                       :uuid             not null, primary key
#  featured_image_alt       :string
#  github_path              :text
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  communication_website_id :uuid             not null
#  university_id            :uuid             not null
#
# Indexes
#
#  idx_comm_website_homes_on_communication_website_id  (communication_website_id)
#  index_communication_website_homes_on_university_id  (university_id)
#
# Foreign Keys
#
#  fk_rails_...  (communication_website_id => communication_websites.id)
#  fk_rails_...  (university_id => universities.id)
#
class Communication::Website::Home < ApplicationRecord
  include WithGit
  include WithMedia

  belongs_to :university
  belongs_to :website, foreign_key: :communication_website_id

  has_rich_text :text
  has_one_attached_deletable :featured_image

  def to_s
    website.to_s
  end

  def git_path(website)
    'content/_index.html'
  end

  def git_dependencies(website)
    [self] + active_storage_blobs
  end

  def git_destroy_dependencies(website)
    [self] + active_storage_blobs
  end
end
