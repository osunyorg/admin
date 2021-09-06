# == Schema Information
#
# Table name: communication_website_pages
#
#  id                       :uuid             not null, primary key
#  about_type               :string
#  description              :text
#  path                     :text
#  position                 :integer          default(0), not null
#  published_at             :datetime
#  slug                     :string
#  title                    :string
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  about_id                 :uuid
#  communication_website_id :uuid             not null
#  parent_id                :uuid
#  university_id            :uuid             not null
#
# Indexes
#
#  index_communication_website_pages_on_about                     (about_type,about_id)
#  index_communication_website_pages_on_communication_website_id  (communication_website_id)
#  index_communication_website_pages_on_parent_id                 (parent_id)
#  index_communication_website_pages_on_university_id             (university_id)
#
# Foreign Keys
#
#  fk_rails_...  (communication_website_id => communication_websites.id)
#  fk_rails_...  (parent_id => communication_website_pages.id)
#  fk_rails_...  (university_id => universities.id)
#

# class Communication::Website::Page < ApplicationRecord
#   belongs_to :university
#   belongs_to :website, foreign_key: :communication_website_id
#   belongs_to :parent, class_name: 'Communication::Website::Page', optional: true
#   belongs_to :about, polymorphic: true, optional: true
#
#   validates :title, presence: true
#
#   before_save :make_path
#
#   def to_s
#     "#{ title }"
#   end
#
#   protected
#
#   def make_path
#     self.path = "#{parent&.path}/#{slug}"
#   end
# end


class Communication::Website::Page
  extend ActiveModel::Naming
  extend ActiveModel::Translation

  attr_accessor :id, :title, :permalink, :content, :raw

  def self.for_website(website)
    return [] if website.repository.blank?
    github = Github.new website.access_token, website.repository
    github.pages
  end

  def self.find(id, website)
    return [] if website.repository.blank?
    github = Github.new website.access_token, website.repository
    github.page_with_id(id)
  end

  def description
    ""
  end

  def slug
    ""
  end

  def path
    permalink
  end

  def persisted?
    true
  end

  def to_s
    "#{ title }"
  end
end
