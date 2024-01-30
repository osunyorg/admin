class CreateLocationJoinTables < ActiveRecord::Migration[7.1]
  def change
    create_join_table :administration_locations, :education_schools, column_options: {type: :uuid} do |t|
      t.index [:"administration_location_id", :"education_school_id"], name: 'index_location_school'
      t.index [:"education_school_id", :"administration_location_id"], name: 'index_school_location'
    end
    create_join_table :administration_locations, :education_programs, column_options: {type: :uuid} do |t|
      t.index [:"administration_location_id", :"education_program_id"], name: 'index_location_program'
      t.index [:"education_program_id", :"administration_location_id"], name: 'index_program_location'
    end
  end
end
