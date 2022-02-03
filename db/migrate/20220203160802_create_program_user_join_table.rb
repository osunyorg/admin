class CreateProgramUserJoinTable < ActiveRecord::Migration[6.1]
  def change
    create_table "education_programs_users", id: false, force: :cascade do |t|
      t.uuid "education_program_id", null: false
      t.uuid "user_id", null: false
      t.index ["education_program_id", "user_id"], name: "index_education_programs_users_on_program_id_and_user_id"
    end
  end
end
