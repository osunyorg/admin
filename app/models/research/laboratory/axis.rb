# == Schema Information
#
# Table name: research_laboratory_axes
#
#  id                     :uuid             not null, primary key
#  meta_description       :text
#  name                   :string
#  position               :integer
#  short_name             :string
#  text                   :text
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  language_id            :uuid             indexed
#  original_id            :uuid             indexed
#  research_laboratory_id :uuid             not null, indexed
#  university_id          :uuid             not null, indexed
#
# Indexes
#
#  index_research_laboratory_axes_on_language_id             (language_id)
#  index_research_laboratory_axes_on_original_id             (original_id)
#  index_research_laboratory_axes_on_research_laboratory_id  (research_laboratory_id)
#  index_research_laboratory_axes_on_university_id           (university_id)
#
# Foreign Keys
#
#  fk_rails_2e93b6ec10  (original_id => research_laboratory_axes.id)
#  fk_rails_92d4555202  (language_id => languages.id)
#  fk_rails_ad2cb9a562  (research_laboratory_id => research_laboratories.id)
#  fk_rails_d334f832b4  (university_id => universities.id)
#
class Research::Laboratory::Axis < ApplicationRecord
  include Localizable
  include LocalizableOrderByNameScope
  include Sanitizable
  include WithUniversity
  include WithPosition

  belongs_to  :laboratory, 
              foreign_key: :research_laboratory_id

  protected

  def last_ordered_element
    Research::Laboratory::Axis.where(
      university_id: university_id,
      research_laboratory_id: research_laboratory_id
    ).ordered.last
  end
end
