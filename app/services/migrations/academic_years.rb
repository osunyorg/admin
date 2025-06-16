class Migrations::AcademicYears
  def self.migrate_all
    Education::AcademicYear.find_each do |year|
      university = year.university
      university.languages.each do |language|
        year.localizations.where(
          university: university,
          language: language
        ).first_or_create
      end
    end
  end
end