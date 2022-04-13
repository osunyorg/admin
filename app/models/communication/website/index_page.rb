# == Schema Information
#
# Table name: communication_website_index_pages
#
#  id                       :uuid             not null, primary key
#  breadcrumb_title         :string
#  description              :text
#  featured_image_alt       :string
#  header_text              :text
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
  include WithUniversity
  include Sanitizable
  include WithFeaturedImage
  include WithBlobs

  enum kind: {
    home: 0,
    communication_posts: 10,
    education_programs: 20,
    research_articles: 30,
    research_volumes: 32,
    legal_terms: 80,
      sitemap: 81,
      privacy_policy: 82,
    persons: 100,
      administrators: 110,
      authors: 120,
      researchers: 130,
      teachers: 140
  }

  belongs_to :website, foreign_key: :communication_website_id

  has_summernote :header_text
  has_summernote :text

  validates :title, presence: true
  validates :path, presence: true, unless: Proc.new { |p| p.home? }

  def to_s
    "#{title}"
  end

end
