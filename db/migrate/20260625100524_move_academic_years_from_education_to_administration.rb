class MoveAcademicYearsFromEducationToAdministration < ActiveRecord::Migration[8.1]
  def up
    rename_table  :education_academic_year_localizations,
                  :administration_academic_year_localizations
    rename_table  :education_academic_years,
                  :administration_academic_years

    rename_table  :education_academic_years_university_people,
                  :administration_academic_years_university_people
    rename_column :administration_academic_years_university_people,
                  :education_academic_year_id,
                  :administration_academic_year_id

    Communication::Website::Permalink
      .where(about_type: "Education::AcademicYear::Localization")
      .update_all(about_type: "Administration::AcademicYear::Localization")
    Communication::Website::GitFile
      .where(about_type: "Education::AcademicYear::Localization")
      .update_all(about_type: "Administration::AcademicYear::Localization")
    Communication::Website::Connection
      .where(indirect_object_type: "Education::AcademicYear")
      .update_all(indirect_object_type: "Administration::AcademicYear")
    Communication::Website::Connection
      .where(indirect_object_type: "Education::AcademicYear::Localization")
      .update_all(indirect_object_type: "Administration::AcademicYear::Localization")
    Search
      .where(about_object_type: "Education::AcademicYear")
      .update_all(
        about_object_type: "Administration::AcademicYear",
        about_localization_type: "Administration::AcademicYear::Localization"
      )
    Communication::Website::Page
      .where(type: "Communication::Website::Page::EducationAcademicYear")
      .update_all(type: "Communication::Website::Page::AdministrationAcademicYear")
  end

  def down
    rename_column :administration_academic_years_university_people,
                  :administration_academic_year_id,
                  :education_academic_year_id
    rename_table  :administration_academic_years_university_people,
                  :education_academic_years_university_people

    rename_table  :administration_academic_years,
                  :education_academic_years
    rename_table  :administration_academic_year_localizations,
                  :education_academic_year_localizations

    Communication::Website::Permalink
      .where(about_type: "Administration::AcademicYear::Localization")
      .update_all(about_type: "Education::AcademicYear::Localization")
    Communication::Website::GitFile
      .where(about_type: "Administration::AcademicYear::Localization")
      .update_all(about_type: "Education::AcademicYear::Localization")
    Communication::Website::Connection
      .where(indirect_object_type: "Administration::AcademicYear")
      .update_all(indirect_object_type: "Education::AcademicYear")
    Communication::Website::Connection
      .where(indirect_object_type: "Administration::AcademicYear::Localization")
      .update_all(indirect_object_type: "Education::AcademicYear::Localization")
    Search
      .where(about_object_type: "Administration::AcademicYear")
      .update_all(
        about_object_type: "Education::AcademicYear",
        about_localization_type: "Education::AcademicYear::Localization"
      )
    Communication::Website::Page
      .where(type: "Communication::Website::Page::AdministrationAcademicYear")
      .update_all(type: "Communication::Website::Page::EducationAcademicYear")
  end
end
