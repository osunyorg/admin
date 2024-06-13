class AddLanguageUniversityJoinTable < ActiveRecord::Migration[7.1]
  def change
    create_join_table :languages, :universities, column_options: {type: :uuid} do |t|
      t.index [:university_id, :language_id]
    end
  end
end
