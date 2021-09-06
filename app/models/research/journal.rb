# == Schema Information
#
# Table name: research_journals
#
#  id            :uuid             not null, primary key
#  access_token  :string
#  description   :text
#  repository    :string
#  title         :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  university_id :uuid             not null
#
# Indexes
#
#  index_research_journals_on_university_id  (university_id)
#
# Foreign Keys
#
#  fk_rails_...  (university_id => universities.id)
#
class Research::Journal < ApplicationRecord
  belongs_to :university
  has_one :website, class_name: 'Communication::Website', foreign_key: :about
  has_many :volumes, foreign_key: :research_journal_id
  has_many :articles, foreign_key: :research_journal_id

  def to_s
    "#{title}"
  end
end
