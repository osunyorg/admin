class CreateJoinTableResearchLaboratoriesUniversityResearchers < ActiveRecord::Migration[7.0]
  def change
    create_join_table :research_laboratories, :university_people, column_options: {type: :uuid} do |t|
      t.index [:research_laboratory_id, :university_person_id], name: 'laboratory_person'
      t.index [:university_person_id, :research_laboratory_id], name: 'person_laboratory'
    end
  end
end
