class CreateAdministrationMember < ActiveRecord::Migration[6.1]
  def change
    create_table :administration_members, id: :uuid do |t|
      t.references :university, null: false, foreign_key: true, type: :uuid
      t.references :user, foreign_key: true, type: :uuid
      t.string :last_name
      t.string :first_name
      t.string :slug
      t.boolean :is_author
      t.boolean :is_researcher
      t.boolean :is_teacher
      t.boolean :is_administrative
      t.timestamps
    end
  end
end
