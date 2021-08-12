# == Schema Information
#
# Table name: research_journals
#
#  id            :uuid             not null, primary key
#  description   :text
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

  def to_s
    "#{title}"
  end
end
