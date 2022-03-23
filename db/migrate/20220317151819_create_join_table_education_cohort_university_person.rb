class CreateJoinTableEducationCohortUniversityPerson < ActiveRecord::Migration[6.1]
  def change
    create_join_table :education_cohorts, :university_people, column_options: {type: :uuid} do |t|
      t.index [:education_cohort_id, :university_person_id], name: 'index_cohort_person'
      t.index [:university_person_id, :education_cohort_id], name: 'index_person_cohort'
    end
  end
end
