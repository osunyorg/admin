class CreateEmergencyMessages < ActiveRecord::Migration[7.0]
  def change
    create_table :emergency_messages, id: :uuid do |t|
      t.references :university, foreign_key: true, type: :uuid, index: { where: "(university_id IS NOT NULL)" }
      t.string :name
      t.string :role
      t.string :subject_fr
      t.string :subject_en
      t.text :content_fr
      t.text :content_en

      t.datetime :delivered_at
      t.timestamps
    end
  end
end
