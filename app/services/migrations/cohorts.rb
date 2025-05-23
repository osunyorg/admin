class Migrations::Cohorts
  def self.migrate_all
    Education::Cohort.find_each do |cohort|
      university = cohort.university
      cohort.university.languages.each do |language|
        cohort.localizations.where(
          university: university,
          language: language
        ).first_or_create
      end
    end
  end
end