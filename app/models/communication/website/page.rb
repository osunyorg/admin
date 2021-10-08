# == Schema Information
#
# Table name: communication_website_pages
#
#  id                       :uuid             not null, primary key
#  about_type               :string
#  description              :text
#  path                     :text
#  position                 :integer          default(0), not null
#  published                :boolean          default(FALSE)
#  slug                     :string
#  text                     :text
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

class Communication::Website::Page < ApplicationRecord
  belongs_to :university
  belongs_to :website,
             foreign_key: :communication_website_id
  belongs_to :parent,
             class_name: 'Communication::Website::Page',
             optional: true
  has_one    :imported_page,
             class_name: 'Communication::Website::Imported::Page',
             foreign_key: :page_id

  validates :title, presence: true

  before_save :make_path
  after_save :publish_to_github

  scope :ordered, -> { order(:path) }
  scope :recent, -> { order(updated_at: :desc).limit(10) }

  def content
    @content ||= github.read_file_at "_pages/#{id}.html"
  end

  def content_without_frontmatter
    frontmatter.content
  end

  def to_s
    "#{ title }"
  end

  protected

  def github
    @github ||= Github.with_site(website)
  end

  def frontmatter
    @frontmatter ||= FrontMatterParser::Parser.new(:md).call(content)
  end

  def make_path
    self.path = "#{parent&.path}/#{slug}".gsub('//', '/')
  end

  def publish_to_github
    github.publish  kind: :pages,
                    file: "#{ id }.html",
                    title: to_s,
                    data: ApplicationController.render(
                      template: 'admin/communication/website/pages/jekyll',
                      layout: false,
                      assigns: { page: self }
                    )
  end
end
