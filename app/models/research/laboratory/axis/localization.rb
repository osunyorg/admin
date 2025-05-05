# == Schema Information
#
# Table name: research_laboratory_axis_localizations
#
#  id               :uuid             not null, primary key
#  meta_description :text
#  name             :string
#  short_name       :string
#  summary          :text
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  about_id         :uuid             indexed
#  language_id      :uuid             indexed
#  university_id    :uuid             indexed
#
# Indexes
#
#  index_research_laboratory_axis_localizations_on_about_id       (about_id)
#  index_research_laboratory_axis_localizations_on_language_id    (language_id)
#  index_research_laboratory_axis_localizations_on_university_id  (university_id)
#
# Foreign Keys
#
#  fk_rails_1d598d7ade  (about_id => research_laboratory_axes.id)
#  fk_rails_5234357e64  (university_id => universities.id)
#  fk_rails_60fd449856  (language_id => languages.id)
#
class Research::Laboratory::Axis::Localization < ApplicationRecord
  include AsLocalization
  include Initials
  include Sanitizable
  include WithUniversity

  has_summernote :summary

  validates :name, presence: true

  def to_s
    "#{name}"
  end
end
