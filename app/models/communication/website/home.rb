# == Schema Information
#
# Table name: communication_website_homes
#
#  id                       :uuid             not null, primary key
#  description              :text
#  featured_image_alt       :string
#  github_path              :text
#  text_new                 :text
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  communication_website_id :uuid             not null, indexed
#  university_id            :uuid             not null, indexed
#
# Indexes
#
#  idx_comm_website_homes_on_communication_website_id  (communication_website_id)
#  index_communication_website_homes_on_university_id  (university_id)
#
# Foreign Keys
#
#  fk_rails_263a15f387  (communication_website_id => communication_websites.id)
#  fk_rails_328fa48682  (university_id => universities.id)
#
class Communication::Website::Home < ApplicationRecord
  include WithGit
  include WithFeaturedImage
  include WithBlobs

  belongs_to :university
  belongs_to :website, foreign_key: :communication_website_id

  has_rich_text :text
  has_summernote :text_new

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

  protected

  def explicit_blob_ids
    super.concat [featured_image&.blob_id]
  end

  def inherited_blob_ids
    [best_featured_image&.blob_id]
  end
end
