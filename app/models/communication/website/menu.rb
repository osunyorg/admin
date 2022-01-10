# == Schema Information
#
# Table name: communication_website_menus
#
#  id                       :uuid             not null, primary key
#  github_path              :text
#  identifier               :string
#  title                    :string
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  communication_website_id :uuid             not null
#  university_id            :uuid             not null
#
# Indexes
#
#  idx_comm_website_menus_on_communication_website_id  (communication_website_id)
#  index_communication_website_menus_on_university_id  (university_id)
#
# Foreign Keys
#
#  fk_rails_...  (communication_website_id => communication_websites.id)
#  fk_rails_...  (university_id => universities.id)
#
class Communication::Website::Menu < ApplicationRecord
  include WithGit

  belongs_to :university
  belongs_to :website, foreign_key: :communication_website_id
  has_many :items, class_name: 'Communication::Website::Menu::Item', dependent: :destroy

  validates :title, :identifier, presence: true
  validates :identifier, uniqueness: { scope: :communication_website_id }

  scope :ordered, -> { order(created_at: :asc) }

  def to_s
    "#{title}"
  end

  def git_path(website)
    "data/menus/#{identifier}.yml"
  end
end
