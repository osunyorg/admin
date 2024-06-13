class ConnectUniversitiesToLanguages < ActiveRecord::Migration[7.1]
  def change
    University.all.each do |university|
      persons_languages_ids = university.university_people.pluck(:language_id).uniq
      orgas_languages_ids = university.university_organizations.pluck(:language_id).uniq
      websites_languages_ids = university.communication_websites.map(&:language_ids).flatten.uniq
      journals_languages_ids =  university.research_journals.pluck(:language_id).uniq
      programs_languages_ids =  university.education_programs.pluck(:language_id).uniq
      languages = Language.where(id: persons_languages_ids + orgas_languages_ids + websites_languages_ids + journals_languages_ids + programs_languages_ids + [university.default_language_id])
      university.languages = languages
    end
  end
end
