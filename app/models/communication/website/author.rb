# == Schema Information
#
# Table name: communication_website_authors
#
#  id                       :uuid             not null, primary key
#  first_name               :string
#  github_path              :text
#  last_name                :string
#  slug                     :string
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  communication_website_id :uuid             not null
#  university_id            :uuid             not null
#  user_id                  :uuid
#
# Indexes
#
#  idx_comm_website_authors_on_communication_website_id  (communication_website_id)
#  index_communication_website_authors_on_university_id  (university_id)
#  index_communication_website_authors_on_user_id        (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (communication_website_id => communication_websites.id)
#  fk_rails_...  (university_id => universities.id)
#  fk_rails_...  (user_id => users.id)
#
class Communication::Website::Author < ApplicationRecord
  include WithGithub
  include WithSlug

  has_rich_text :biography

  belongs_to :university
  belongs_to :user, optional: true
  belongs_to :website,
             foreign_key: :communication_website_id
  has_many :posts,
           class_name: 'Communication::Website::Post',
           dependent: :nullify

  validates :slug, uniqueness: { scope: :communication_website_id }

  scope :ordered, -> { order(:last_name, :first_name) }

  def to_s
    "#{last_name} #{first_name}"
  end

  def github_path_generated
    "_authors/#{slug}.html"
  end

  def to_jekyll
    ApplicationController.render(
      template: 'admin/communication/website/authors/jekyll',
      layout: false,
      assigns: { author: self }
    )
  end

end
