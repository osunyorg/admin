class MoveCohortsFromEducationToAdministration < ActiveRecord::Migration[8.1]
  def up
    rename_table  :education_cohort_localizations,
                  :administration_cohort_localizations
    rename_table  :education_cohorts,
                  :administration_cohorts

    rename_table  :education_cohorts_university_people,
                  :administration_cohorts_university_people
    rename_column :administration_cohorts_university_people,
                  :education_cohort_id,
                  :administration_cohort_id

    Communication::Website::Permalink
      .where(about_type: "Education::Cohort::Localization")
      .update_all(about_type: "Administration::Cohort::Localization")
    Communication::Website::GitFile
      .where(about_type: "Education::Cohort::Localization")
      .update_all(about_type: "Administration::Cohort::Localization")
    Communication::Website::Connection
      .where(indirect_object_type: "Education::Cohort")
      .update_all(indirect_object_type: "Administration::Cohort")
    Communication::Website::Connection
      .where(indirect_object_type: "Education::Cohort::Localization")
      .update_all(indirect_object_type: "Administration::Cohort::Localization")
    Search
      .where(about_object_type: "Education::Cohort")
      .update_all(
        about_object_type: "Administration::Cohort",
        about_localization_type: "Administration::Cohort::Localization"
      )
  end

  def down
    rename_column :administration_cohorts_university_people,
                  :administration_cohort_id,
                  :education_cohort_id
    rename_table  :administration_cohorts_university_people,
                  :education_cohorts_university_people

    rename_table  :administration_cohorts,
                  :education_cohorts
    rename_table  :administration_cohort_localizations,
                  :education_cohort_localizations

    Communication::Website::Permalink
      .where(about_type: "Administration::Cohort::Localization")
      .update_all(about_type: "Education::Cohort::Localization")
    Communication::Website::GitFile
      .where(about_type: "Administration::Cohort::Localization")
      .update_all(about_type: "Education::Cohort::Localization")
    Communication::Website::Connection
      .where(indirect_object_type: "Administration::Cohort")
      .update_all(indirect_object_type: "Education::Cohort")
    Communication::Website::Connection
      .where(indirect_object_type: "Administration::Cohort::Localization")
      .update_all(indirect_object_type: "Education::Cohort::Localization")
    Search
      .where(about_object_type: "Administration::Cohort")
      .update_all(
        about_object_type: "Education::Cohort",
        about_localization_type: "Education::Cohort::Localization"
      )
  end
end
