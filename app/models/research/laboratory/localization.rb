# == Schema Information
#
# Table name: research_laboratory_localizations
#
#  id                 :uuid             not null, primary key
#  address_additional :string
#  address_name       :string
#  name               :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  about_id           :uuid             indexed
#  language_id        :uuid             indexed
#  university_id      :uuid             indexed
#
# Indexes
#
#  index_research_laboratory_localizations_on_about_id       (about_id)
#  index_research_laboratory_localizations_on_language_id    (language_id)
#  index_research_laboratory_localizations_on_university_id  (university_id)
#
# Foreign Keys
#
#  fk_rails_282a6ed9c7  (language_id => languages.id)
#  fk_rails_73cdca65a5  (university_id => universities.id)
#  fk_rails_975d06fc20  (about_id => research_laboratories.id)
#
class Research::Laboratory::Localization < ApplicationRecord
  include AsLocalization
  include HasGitFiles
  include Initials
  include Sanitizable
  include WithUniversity

  validates :name, presence: true

  def git_path(website)
    "data/laboratory.yml"
  end

  def template_static
    "admin/research/laboratories/static"
  end

  def to_s
    "#{name}"
  end
end
