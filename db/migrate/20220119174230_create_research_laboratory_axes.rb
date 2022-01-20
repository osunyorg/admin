class CreateResearchLaboratoryAxes < ActiveRecord::Migration[6.1]
  def change
    create_table :research_laboratory_axes, id: :uuid do |t|
      t.references :university, null: false, foreign_key: true, type: :uuid
      t.references :research_laboratory, null: false, foreign_key: true, type: :uuid
      t.string :name
      t.text :description
      t.integer :position

      t.timestamps
    end
  end
end
