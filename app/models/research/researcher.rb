# == Schema Information
#
# Table name: research_researchers
#
#  id            :uuid             not null, primary key
#  first_name    :string
#  last_name     :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  university_id :uuid
#  user_id       :uuid
#
# Indexes
#
#  idx_researcher_university              (university_id)
#  index_research_researchers_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (university_id => universities.id)
#  fk_rails_...  (user_id => users.id)
#
class Research::Researcher < ApplicationRecord
  include WithJekyll
  include WithPublicationToWebsites

  has_rich_text :biography

  belongs_to :university
  belongs_to :user, optional: true
  has_and_belongs_to_many :articles, class_name: 'Research::Journal::Article'
  has_many :journals, through: :articles
  has_many :websites, -> { distinct }, through: :journals

  scope :ordered, -> { order(:last_name, :first_name) }

  def to_s
    "#{ first_name } #{ last_name }"
  end

  def github_path
    "_authors/#{self.id}.md"
  end
end
