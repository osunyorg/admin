# == Schema Information
#
# Table name: research_thesis_localizations
#
#  id            :uuid             not null, primary key
#  abstract      :text
#  title         :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  about_id      :uuid             indexed
#  language_id   :uuid             indexed
#  university_id :uuid             indexed
#
# Indexes
#
#  index_research_thesis_localizations_on_about_id       (about_id)
#  index_research_thesis_localizations_on_language_id    (language_id)
#  index_research_thesis_localizations_on_university_id  (university_id)
#
# Foreign Keys
#
#  fk_rails_2208771909  (university_id => universities.id)
#  fk_rails_b484cf5bfa  (about_id => research_theses.id)
#  fk_rails_bd6b0dc62a  (language_id => languages.id)
#
class Research::Thesis::Localization < ApplicationRecord
  include AsLocalization
  include Initials
  include Sanitizable
  include WithUniversity

  def to_s
    "#{title}"
  end
end
