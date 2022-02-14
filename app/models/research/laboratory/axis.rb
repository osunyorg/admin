# == Schema Information
#
# Table name: research_laboratory_axes
#
#  id                     :uuid             not null, primary key
#  description            :text
#  name                   :string
#  position               :integer
#  short_name             :string
#  text_new               :text
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  research_laboratory_id :uuid             not null, indexed
#  university_id          :uuid             not null, indexed
#
# Indexes
#
#  index_research_laboratory_axes_on_research_laboratory_id  (research_laboratory_id)
#  index_research_laboratory_axes_on_university_id           (university_id)
#
# Foreign Keys
#
#  fk_rails_ad2cb9a562  (research_laboratory_id => research_laboratories.id)
#  fk_rails_d334f832b4  (university_id => universities.id)
#
class Research::Laboratory::Axis < ApplicationRecord
  include WithPosition

  has_rich_text :text

  belongs_to :university
  belongs_to :laboratory, foreign_key: :research_laboratory_id

  def to_s
    "#{name}"
  end

  protected

  def last_ordered_element
    Research::Laboratory::Axis.where(
      university_id: university_id,
      research_laboratory_id: research_laboratory_id
    ).ordered.last
  end
end
