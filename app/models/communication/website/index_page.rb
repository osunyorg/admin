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
class Communication::Website::IndexPage < ApplicationRecord
  include WithGit
  include WithFeaturedImage
  include WithBlobs

  enum kind: {
    home: 0,
    communication_posts: 10,
    education_programs: 20,
    research_articles: 30,
    research_volumes: 32,
    persons: 100,
      administrators: 110,
      authors: 120,
      researchers: 130,
      teachers: 140
  }

  belongs_to :university
  belongs_to :website, foreign_key: :communication_website_id

  has_summernote :header_text
  has_summernote :text

  validates :title, presence: true
  validates :path, presence: true, unless: Proc.new { |p| p.home? }

  def to_s
    "#{title}"
  end

  def git_dependencies(website)
    [self] + active_storage_blobs + website.menus
  end

  def git_destroy_dependencies(website)
    [self] + active_storage_blobs
  end

  def home
    @home ||= Communication::Website::IndexPage::Home.find(id)
  end

  def education_programs
    @education_programs ||= Communication::Website::IndexPage::EducationPrograms.find(id)
  end

  protected

  def explicit_blob_ids
    super.concat [featured_image&.blob_id]
  end

  def inherited_blob_ids
    [best_featured_image&.blob_id]
  end

end
