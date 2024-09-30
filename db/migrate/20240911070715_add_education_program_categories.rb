class AddEducationProgramCategories < ActiveRecord::Migration[7.1]
  def change
    create_table :education_program_categories, id: :uuid do |t|
      t.boolean :is_taxonomy, default: false
      t.integer :position
      t.references :parent, foreign_key: { to_table: :education_program_categories }, type: :uuid
      # # TODO L10N : To remove
      # Créé juste pour ne pas casser les scopes
      t.references :original, foreign_key: { to_table: :education_program_categories }, type: :uuid
      t.references :university, foreign_key: true, type: :uuid

      t.timestamps
    end

    create_table :education_program_category_localizations, id: :uuid do |t|
      t.string :slug
      t.string :name

      t.references :about, foreign_key: { to_table: :education_program_categories }, type: :uuid
      t.references :language, foreign_key: true, type: :uuid
      t.references :university, foreign_key: true, type: :uuid

      t.timestamps
    end

    create_join_table :education_programs, :education_program_categories, column_options: {type: :uuid} do |t|
      t.index [:education_program_id, :education_program_category_id], name: 'program_category'
      t.index [:education_program_category_id, :education_program_id], name: 'category_program'
    end
  end
end
